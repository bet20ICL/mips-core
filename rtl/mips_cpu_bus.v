module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

    // Control Signals
    logic pc_write;
    logic pc_or_aluout;
    logic mem_read;
    logic mem_write;
    logic ir_write;
    logic a_write;
    logic b_write;
    logic mem_to_reg;
    logic reg_dst;
    logic mdr_write;
    logic reg_write;
    logic alu_out_write;
    logic alu_srca;
    logic[1:0] alu_srcb;
    logic[1:0] alu_op;
    logic pc_source;

    //Regfile I/O & IR outputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;
    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic[31:0] read_data1;
    logic[31:0] read_data2;
    logic[31:0] register_v0;
    logic[4:0] reg_write_index_beforemux;
    logic[15:0] offset_b4extend;

    //control block input
    logic[5:0] instr_opcode;

    //IR register
    instruction_register IR(
        .readdata(readdata),
        .ir_write(ir_write),
        .instr_opcode(instr_opcode),
        .reg_a_read_index(reg_a_read_index),
        .reg_b_read_index(reg_b_read_index),
        .reg_write_index_beforemux(reg_write_index_beforemux),
        .offset_b4extend(offset_b4extend)
    );

    //MDR register
    memory_data_reg MDR(
        .readdata(readdata),
        .mdr_write(mdr_write),
        .reg_write_data_b4mux(reg_write_data_b4mux)
    );

    assign reg_write_index = reg_dst ? reg_write_index_beforemux : reg_b_read_index;
    assign reg_write_data = mem_to_reg ? reg_write_data_b4mux : alu_out;

    regfile registerfiles(
        .r_clk(clk),
        .reset(reset),
        .r_clk_enable(clk_enable),
        .read_reg1(reg_a_read_index),
        .read_reg2(reg_b_read_index),
        .write_control(reg_write),
        .write_reg(reg_write_index),
        .write_data(reg_write_data),
        .read_data1(reg_a_read_data),
        .read_data2(reg_b_read_data),
        .register_v0(register_v0)
    );

    //reg a & b outputs
    logic[31:0] aout;
    logic[31:0] bout;

    reg_a rega(
        .a_write(a_write),
        .regout(read_data1),
        .aout(aout)
    );
    reg_b regb(
        .b_write(b_write),
        .regout(read_data2),
        .bout(bout)
    );

    //pc stuff
    logic[31:0] next_instr_addr;
    logic[31:0] curr_addr;

    assign next_instr_addr = pc_source ? alu_out : alu_out_b4reg;

    // need to implement muxes and adder like in harvard for PC: PC+4 still i think
    pc_bus pc(
        .clk(clk),
        .next_addr(next_instr_addr),
        .reset(reset),
        .pc_write(pc_write),
        .curr_addr(curr_addr)
    );

    logic[31:0] offset;
    logic[31:0] offset_shifted;
    assign offset {16'h0, offset_b4extend};
    assign offset_shifted = offset << 2;

    //ALU stuff
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    logic[3:0] alu_control_out;
    logic[31:0] alu_out;
    logic[31:0] alu_out_b4reg;

    assign alu_op1 = alu_srca ? aout : curr_addr;
    assign alu_op2 = (alu_srcb=0) ? bout : (alu_srcb=1 ? 4 : (alu_srcb=2 ? offset : offset_shifted))
    
    alu alu(
        .control(alu_control_out),
        .op1(alu_op1),
        .op2(alu_op2),
        .result(alu_out_b4reg),
        // some missing ?? in harvard too
    );
    alu_out_reg aluoutreg(
        .alu_out_write(alu_out_write),
        .alu_out_b4reg(alu_out_b4reg),
        .alu_out(alu_out)
    );

    assign writedata = bout;
    assign address = pc_or_aluout ? alu_out : curr_addr;

endmodule