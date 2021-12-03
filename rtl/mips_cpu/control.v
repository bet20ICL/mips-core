module control(
    input logic[5:0] instr_opcode,
    output logic reg_dst,
    output logic branch,
    output logic mem_read,
    output logic mem_to_reg,
    output logic[1:0] alu_op,
    output logic mem_write,
    output logic alu_src,
    output logic reg_write,
    output logic jump
);
    logic r_format;
    logic lw;
    logic sw;
    logic beq;

    assign r_format = (instr_opcode == 0);
    assign lw = (instr_opcode == 6'b100011);
    assign sw = (instr_opcode == 6'b101011);
    assign beq = (instr_opcode == 6'b000100);

    assign reg_dst = (r_format);
    assign alu_src = (lw || sw);  
    assign mem_to_reg = (lw);
    assign reg_write = (lw);
    assign mem_read = (lw);
    assign mem_write = (sw);
    assign branch = (beq);
    assign alu_op[1] = (r_format);
    assign alu_op[0] = (beq);
        
endmodule



