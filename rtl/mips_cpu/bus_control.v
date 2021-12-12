module control(
    input logic[31:0] ir,
    output logic      ALUsrcA,
    output logic      MemWrite,
    output logic      ALUop,
    output logic      RegDst,
    output logic      RegWrite,

);

    logic[5:0] instr_opcode;
    assign instr_opcode = instr_w_reset[31:26];

    assign alu_src = instr_opcode >= 4 ? 1 : 0;
    assign mem_write = instr_opcode == 43;
    //and with state from state machine
    assign reg_dst = instr_opcode == 32 || instr_opcode == 33 ? 1 : 0;
    assign reg_write = instr_opcode != 8 ? 1 : 0;