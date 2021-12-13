module instruction_regsiter(

    //instruction input
    input logic[31:0] readdata,
    //control line for writing to register
    input logic ir_write,
    output logic[5:0] instr_opcode,
    output logic[4:0] reg_a_read_index,
    output logic[4:0] reg_b_read_index,
    output logic[4:0] reg_write_index_beforemux,
    output logic[15:0] offset_b4extend

);

    reg[31:0] instruction_register;

    always_comb begin
        if(ir_write) begin
            instruction_register = readdata;
        end
    end

    assign instr_opcode = instruction_register[31:26];
    assign reg_a_read_index = instruction_register[25:21];
    assign reg_b_read_index = instruction_register[20:16];
    assign reg_write_index_beforemux = instruction_register[15:11];
    assign offset_b4extend = instruction_register[15:0];


endmodule