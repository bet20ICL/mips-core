//Combinatorial read of data, no write

module instruction_ram(
    input logic[31:0] instr_address,
    output logic[31:0] instr_readdata,
    input logic[31:0] test_inst,
    input logic test_write
);

    logic[1:0] addr = instr_address[1:0];

    reg [31:0] memory [3:0];

    initial begin
    

        memory[0] = 32'd3;
        memory[1] = 32'd9;
        memory[2] = 32'd14;
        memory[3] = 32'd123;

    end

    always_comb begin
        assign instr_readdata = memory[addr[1:0]];
        if (test_write) begin
            assign memory[instr_address] = test_inst;
        end
    end

    

endmodule