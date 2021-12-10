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

    logic mem_read;
    assign mem_read = (lw);

    logic mem_to_reg;
    assign mem_to_reg = (lw);

    logic alu_instr;
    assign alu_instr = instr_opcode[5:4] == 0;
    logic l_type;
    assign l_type = instr_opcode[5:3] == 3'b100;
    
    logic reg_write;
    assign reg_write = (alu_instr || l_type || link_reg || link_const);

    logic mem_write;
    assign mem_write = (sw);

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
    assign muldiv = (instr_opcode == 17) || (instr_opcode == 19) || (instr_opcode == 24) || (instr_opcode == 25) || (instr_opcode == 26) || (instr_opcode == 27);

    logic mfhi;
    assign mfhi = instr_opcode == 16;

    logic mflo;
    assign mflo = instr_opcode == 18;

    // Data RAM read/write enable control
    assign data_write = active ? mem_write : 0;
    assign data_read = mem_read;
    
    //Regfile inputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;

    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic reg_write_enable;

    assign reg_a_read_index = instr_readdata[25:21];
    assign reg_b_read_index = instr_readdata[20:16];
    assign reg_write_index =  link_const ? 5'd31 : (reg_dst ? instr_readdata[15:11] : instr_readdata[20:16]);
    assign reg_write_enable = active && reg_write;

    assign reg_write_data = (link_const || link_reg) ? curr_addr_p4 + 4 : (mfhi ? hi_out : (mflo ? lo_out : (mem_to_reg ? data_readdata : result)));
    
    //Regfile outputs
    logic[31:0] reg_a_read_data;
    logic[31:0] reg_b_read_data;

    always @(posedge clk) begin
        $display("i_word=%b, active=%h, reg_write=%h", instr_readdata, active, reg_write);
        $display("reg_a_read_index=%d, reg_b_read_index=%d", reg_a_read_index, reg_b_read_index);
        $display("reg_write_data=%h, result=%d, reg_write_index=%h", reg_write_data, result, reg_write_index);
        $display("pc=%h", curr_addr);
    end

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

    assign data_writedata = reg_b_read_data;

    //ALU inputs
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    //ALU outputs
    logic[31:0] result;
    logic[31:0] result_lo;
    logic[31:0] result_hi;
    logic[31:0] memaddroffset;
    logic b_flag;
    
    //Assigning ALU inputs
    assign alu_op1 = reg_a_read_data;
    assign alu_op2 = reg_b_read_data;

    //Assigning ALU outputs
    assign data_address = memaddroffset; 

    alu cpu_alu(
        .op1(alu_op1),
        .op2(alu_op2),
        .instructionword(instr_readdata),
        .result(result),
        .lo(result_lo),
        .hi(result_hi),
        .memaddroffset(memaddroffset),
        .b_flag(b_flag)
    );

    // HI/LO Register inputs
    logic hl_reg_enable;
    assign hl_reg_enable = (clk_enable && muldiv && cpu_active);

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
    
    //PC
    logic[31:0] next_instr_addr;
    logic[31:0] curr_addr;
    logic[31:0] curr_addr_p4;
    assign curr_addr_p4 = curr_addr + 4;
    logic[31:0] offset;
    assign offset = {instr_readdata[15] ? 16'hFFFF : 16'h0, instr_readdata[15:0]};

    always @(*) begin
        if (b_flag) begin
            next_instr_addr = curr_addr_p4 + offset << 2;
        end
        else if (j_imm) begin 
            next_instr_addr = {curr_addr_p4[31:28], instr_readdata[25:0], 2'b00};
        end
        else if (j_reg) begin
            next_instr_addr = reg_a_read_data;
        end
        else begin
            next_instr_addr = curr_addr_p4;
        end
    end

    assign instr_address = curr_addr;

    logic cpu_active;
    always @(posedge clk) begin
       if (reset) begin
           cpu_active = 1;
       end
       else begin
           cpu_active = (curr_addr != 32'h0);
       end
    end
    assign active = cpu_active;

    logic pc_enable;
    assign pc_enable = clk_enable && cpu_active;

    pc cpu_pc(
        .clk(clk),
        .reset(reset),
        .next_addr(next_instr_addr),
        .curr_addr(curr_addr),
        .enable(pc_enable)
    );

endmodule
