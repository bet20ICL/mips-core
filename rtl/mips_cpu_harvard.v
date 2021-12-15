module mips_cpu_harvard(
    /* Standard signals */
    input logic     clk,
    input logic     reset,
    output logic    active,
    output logic [31:0] register_v0,

    /* New clock enable. See below. */
    input logic     clk_enable,

    /* Combinatorial read access to instructions */
    output logic[31:0]  instr_address,
    input logic[31:0]   instr_readdata,

    /* Combinatorial read and single-cycle write access to instructions */
    output logic[31:0]  data_address,
    output logic        data_write,
    output logic        data_read,
    output logic[31:0]  data_writedata,
    input logic[31:0]  data_readdata
);
    
    //Control Signals
    logic[5:0] instr_opcode;
    assign instr_opcode = instr_readdata[31:26];
    logic[5:0] funct_code;
    assign funct_code = instr_readdata[5:0];

    logic r_format;
    logic lw;
    logic sw;

    assign r_format = (instr_opcode == 0);
    assign lw = (instr_opcode == 6'b100011);
    assign sw = (instr_opcode == 6'b101011);
    
    logic movefrom; // mfhi or mflo
    assign movefrom = (instr_opcode == 1 || instr_opcode == 3);

    logic reg_dst;
    assign reg_dst = (r_format);

    logic load_instr; // load instructions
    assign load_instr = (instr_opcode[5:3] == 3'b100);

    logic mem_to_reg;
    assign mem_to_reg = (lw);

    logic alui_instr;
    assign alui_instr = instr_opcode[5:3] == 3'b001;

    
    logic reg_write;
    assign reg_write = ((r_format && !muldiv) || alui_instr || load_instr || link_reg || link_const);
    // case(opcode)
    //         0: case(funct)
    //             0,2,3,4,6,7,9,16,18,32,33,34,35,36,37,38,39,42,43 : writereg = 1;
    //         endcase
    //         1: case(addr_rt)
    //             16,17 : writereg = 1;
    //         endcase
    //         3,8,9,10,11,12,13,14,15,32,33,34,36,37 : write_reg = 1;
    // endcase

    logic store_instr;
    assign store_instr = instr_opcode[5:3] == 3'b101;

    logic link_const; // jump or branch with link to r31
    assign link_const = (instr_opcode == 3) || (instr_opcode == 1 && instr_readdata[20] == 1);

    logic link_reg; //jalr
    assign link_reg = (instr_opcode == 0 && instr_readdata[5:0] == 6'b001001);

    logic j_imm; // j or jal
    assign j_imm = (instr_opcode == 2 || instr_opcode == 3);

    logic j_reg; // jr or jalr
    assign j_reg = (instr_opcode==0) && (instr_readdata[5:0] == 6'b001001 || instr_readdata[5:0] == 6'b001000);

    // multiplication control
    logic muldiv;   //high if hi/lo need to be changed
    assign muldiv = r_format && (funct_code[4:3] == 2'b11 || funct_code == 6'b010001 || funct_code == 6'b010011);

    logic mfhi;
    assign mfhi = r_format && (funct_code == 6'b010000);

    logic mflo;
    assign mflo = r_format && (funct_code == 6'b010010);

    
    
    //Regfile inputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;

    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic reg_write_enable;

    assign reg_a_read_index = instr_readdata[25:21];
    assign reg_b_read_index = instr_readdata[20:16];
    assign reg_write_index =  link_const ? 5'd31 : (reg_dst ? instr_readdata[15:11] : instr_readdata[20:16]);
    assign reg_write_enable = cpu_active && state && reg_write;

    logic[31:0] load_data;

    load_block cpu_load_block(
        .address(effective_addr),
        .instr_word(instr_readdata),
        .datafromMem(data_readdata),
        .out_transformed(load_data) 
    );

    assign reg_write_data = (link_const || link_reg) ? (delay_slot + 4): (mfhi ? hi_out : (mflo ? lo_out : (mem_to_reg ? load_data : result)));
    
    //Regfile outputs
    logic[31:0] reg_a_read_data;
    logic[31:0] reg_b_read_data;

    regfile register(
        .r_clk(clk),
        .reset(reset),
        .r_clk_enable(clk_enable),
        
        .read_reg1(reg_a_read_index),
        .read_reg2(reg_b_read_index),
        .write_control(reg_write_enable),
        .write_reg(reg_write_index),
        .write_data(reg_write_data),
        .read_data1(reg_a_read_data),
        .read_data2(reg_b_read_data),
        .register_v0(register_v0)
    );

    //ALU inputs
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    //ALU outputs
    logic[31:0] result;
    logic[31:0] result_lo;
    logic[31:0] result_hi;
    logic[31:0] effective_addr;
    logic b_flag;
    
    //Assigning ALU inputs
    assign alu_op1 = reg_a_read_data;
    assign alu_op2 = reg_b_read_data;

    alu cpu_alu(
        .op1(alu_op1),
        .op2(alu_op2),
        .instructionword(instr_readdata),
        .result(result),
        .lo(result_lo),
        .hi(result_hi),
        .memaddroffset(effective_addr),
        .b_flag(b_flag)
    );

    // HI/LO Register inputs
    logic hl_reg_enable;
    assign hl_reg_enable = (clk_enable && muldiv && cpu_active && state == 1);

    // HI/LO Register outputs
    logic[31:0] lo_out;
    logic[31:0] hi_out;

    hl_reg lo(
        .clk(clk),
        .reset(reset),
        .enable(hl_reg_enable),
        .data_in(result_lo),
        .data_out(lo_out)
    );

    hl_reg hi(
        .clk(clk),
        .reset(reset),
        .enable(hl_reg_enable),
        .data_in(result_hi),
        .data_out(hi_out)
    );

    // Data RAM
    

    // Data RAM read/write enable control
    assign data_write = cpu_active && state && store_instr;

    logic sb;
    assign sb = instr_opcode == (6'b101000);
    logic sh;
    assign sh = instr_opcode == (6'b101001);
    logic partial_store;
    assign partial_store = sb || sh;

    assign data_read = load_instr || (partial_store && !state);

    // data address
    // data address controller
    logic lwl;
    assign lwl = instr_opcode[5:0] == 6'b100110;
    logic lwr;
    assign lwr = instr_opcode[5:0] == 6'b100010;
    always @(*) begin
        if (lwl || lwr) begin
            // to do
        end
        else if (instr_opcode[5] == 1) begin // all load / store instructions
            data_address = {effective_addr[31:2], 2'b00};
        end
    end

    // data_writedata
    // store block
    store_block dut(
        .opcode(instr_opcode),
        .regword(reg_b_read_data),
        .dataword(data_readdata),
        .eff_addr(effective_addr),
        .storedata(data_writedata)
    );
    
    //PC
    logic[31:0] curr_addr;
    
    // for building branch address
    logic[17:0] b_imm;
    assign b_imm = instr_readdata[15:0] << 2;
    logic[31:0] b_offset;
    assign b_offset = {b_imm[17] ? 14'h3FFF : 14'h0, b_imm};

    logic [31:0] next_delay_slot;
    always @(*) begin
        if (b_flag) begin
            next_delay_slot = delay_slot + b_offset;
        end
        else if (j_imm) begin 
            next_delay_slot = {delay_slot[31:28], instr_readdata[25:0], 2'b0};
        end
        else if (j_reg) begin
            next_delay_slot = reg_a_read_data;
        end
        else begin
            next_delay_slot = curr_addr + 4;
        end
    end

    logic state;
    logic cpu_active;
    logic [31:0] delay_slot;
    
    assign active = cpu_active;
    always @(posedge clk) begin
        if (clk_enable) begin
            if (reset) begin
                curr_addr <= 32'hBFC00000;
                delay_slot <= 32'hBFC00004;
                cpu_active <= 1;
                state <= 0;
            end 
            else begin
                if (cpu_active) begin
                    if (state == 0) begin
                        state <= 1;
                    end 
                    else if (state == 1) begin
                        state <= 0;
                        curr_addr <= delay_slot;
                        delay_slot <= next_delay_slot;
                    end
                    if (delay_slot == 0) begin
                        cpu_active <= 0;
                    end
                end
            end
        end
    end
    
    assign instr_address = curr_addr;

endmodule
