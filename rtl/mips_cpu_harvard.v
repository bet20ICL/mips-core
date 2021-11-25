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
    
    //alu_src = 1 if instruction is i type (current implementation for simplified instruction set only, change later)
    logic alu_src;
    assign alu_src = instr_opcode >= 4 ? 1 : 0;

    //reg_dst = 1 if instruction is r type (current implementation for simplified instruction set only, change later)
    logic reg_dst;
    assign reg_dst = instr_opcode == 32 || instr_opcode == 33 ? 1 : 0; 

    //mem_to_reg = 1 if instruction is load (current implementation for simplified instruction set only, change later)
    logic mem_to_reg;
    assign mem_to_reg = instr_opcode == 34 ? 1 : 0;
    
    //reg_write = 1 if instruction changes register file (i.e. not a j type?) (current implementation for simplified instruction set only, change later)
    logic reg_write;
    assign reg_write = instr_opcode != 8 ? 1 : 0;

    //mem_write = 1 to write to data memory, just sw for now
    logic mem_write;
    assign mem_write = instr_opcode == 43;

    //mem_read = 1 to read from data memory, just lw for now
    logic mem_read;
    assign mem_read = instr_opcode == 34 ? 1 : 0;

    //branch = 1 if jump/branch instruction, just jr for now
    logic branch;
    assign branch = instr_opcode == 8;

    //function code for r type instructions only
    logic[5:0] f_code;
    assign f_code = instr_readdata[5:0];
    
    

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
        .read_data2(reg_b_read_data)
    );

    //ALU inputs
    logic[2:0] alu_control_out;
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    //ALU outputs
    logic[31:0] alu_out;
    logic alu_z_flag;
    
    //Assigning ALU inputs
    alu_control cpu_alu_control(
        .alu_opcode(instr_opcode),
        .alu_fcode(f_code),
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

    logic[31:0] next_instr_addr;
    logic[31:0] curr_addr;
    assign next_instr_addr = branch ? curr_addr + 4 + offset << 2 : curr_addr + 4;
    assign instr_address = curr_addr;
    pc cpu_pc(
        .clk(clk),
        .next_addr(next_instr_addr),
        .curr_addr(curr_addr)
    );

endmodule
