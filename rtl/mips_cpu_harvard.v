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

    //i_type = 1 if instruction is i type (current implementation for simplified instruction set only, change later)
    logic i_type;
    assign i_type = instr_opcode >= 4 ? 1 : 0;

    //r_type = 1 if instruction is r type (current implementation for simplified instruction set only, change later)
    logic r_type;
    assign r_type = instr_opcode == 32 || instr_opcode == 33 ? 1 : 0; 
    
    //load = 1 if instruction is load (current implementation for simplified instruction set only, change later)
    logic load;
    assign load = instr_opcode == 34 ? 1 : 0;
    
    //reg_Change = 1 if instruction changes register file (i.e. not a j type?) (current implementation for simplified instruction set only, change later)
    logic reg_change;
    assign reg_change = instr_opcode != 8 ? 1 : 0;

    //Regfile inputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;

    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic reg_write_enable;

    assign reg_a_read_index = instr_readdata[25:21];
    assign reg_b_read_index = instr_readdata[20:16];
    assign reg_write_index = r_type ? instr_readdata[15:11] : instr_readdata[20:16];
    assign reg_write_data = load ? data_readdata : alu_out;
    assign reg_write_enable = reg_change;
    
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

    //ALU wiring
    logic[3:0] alu_control;
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    logic[31:0] alu_out;
    logic alu_z_flag;
    
    assign alu_op1 = reg_a_read_data;

    logic[31:0] offset;
    assign offset = {16'h0, instr_readdata[15:0]};
    assign alu_op2 = i_type ? offset : reg_b_read_data;

    alu cpu_alu(
        .control(alu_control),
        .op1(alu_op1),
        .op2(alu_op2),
        .result(alu_out),
        .z_flag(alu_z_flag)
    );

    logic next_instr_addr = ;

    always @(posedge clk) begin
        
    end

endmodule
