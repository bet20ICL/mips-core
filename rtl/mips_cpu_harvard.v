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

    logic reg_dst;
    logic branch;
    logic mem_read;
    logic mem_to_reg;
    logic[1:0] alu_op;
    logic mem_write;
    logic alu_src;
    logic reg_write;
    
    control cpu_control(
        .instr_opcode(instr_opcode),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );
    
    
    //Regfile inputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;

    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic reg_write_enable;

    assign reg_a_read_index = instr_readdata[25:21];
    assign reg_b_read_index = instr_readdata[20:16];
    assign reg_write_index = reg_dst ? instr_readdata[15:11] : instr_readdata[20:16];
    assign reg_write_data = mem_to_reg ? data_readdata : alu_out;
    assign reg_write_enable = reg_write;
    
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
    logic[3:0] alu_control_out;
    logic[5:0] alu_fcode;
    assign alu_fcode = instr_readdata[5:0];
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    //ALU outputs
    logic[31:0] alu_out;
    logic alu_z_flag;
    
    //Assigning ALU inputs
    alu_control cpu_alu_control(
        .alu_opcode(alu_op),
        .alu_fcode(alu_fcode),
        .alu_control_out(alu_control_out)
    );

    assign alu_op1 = reg_a_read_data;

    logic[31:0] offset;
    assign offset = {16'h0, instr_readdata[15:0]};
    assign alu_op2 = alu_src ? offset : reg_b_read_data;

    //Assigning ALU outputs
    assign data_address = alu_out; 

    alu cpu_alu(
        .control(alu_control_out),
        .op1(alu_op1),
        .op2(alu_op2),
        .result(alu_out),
        .z_flag(alu_z_flag)
    );

    
    //PC
    logic[31:0] next_instr_addr;
    logic[31:0] curr_addr;
    logic[31:0] curr_addr_p4;
    assign curr_addr_p4 = curr_addr + 4;
    
    logic j_type; //j or jal

    assign j_type = (instr_opcode == 2 || instr_opcode[5:0] == 3);
    logic jr_type; //jr or jrl
    assign jr_type = ((instr_opcode == 0) && ((alu_fcode == 001001) || (alu_fcode == 001000)));
    logic tmp;
    assign tmp = (alu_fcode == 001000);

    initial begin
        repeat(10) begin 
            @(posedge clk) begin
                $display("tmp is %b", tmp);
                $display("full instr is %b, instr is %d, alu_fcode is %b jr_type is %b",instr_readdata, instr_opcode, alu_fcode, jr_type);
            end
        end
    end

    always @(*) begin
        if (branch && alu_z_flag) begin
            next_instr_addr = curr_addr_p4 + offset << 2;
        end
        else if (j_type) begin 
            next_instr_addr = {curr_addr_p4[31:28], instr_readdata[25:0], 2'b00};
        end
        else if (jr_type) begin
            next_instr_addr = reg_a_read_data;
        end
        else begin
            next_instr_addr = curr_addr_p4;
        end
    end

    assign instr_address = curr_addr;
    pc cpu_pc(
        .clk(clk),
        .reset(reset),
        .next_addr(next_instr_addr),
        .curr_addr(curr_addr)
    );

endmodule
