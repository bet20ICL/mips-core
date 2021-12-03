//Combinatorial read of data, no write

module instruction_ram(
    input logic[31:0] instr_address,
    output logic[31:0] instr_readdata
);
    parameter RAM_INIT_FILE = "";
    reg [31:0] memory1 [65535:0];
    initial begin
        integer i;
        for (i = 0; i < 5; i++) begin
            memory1[i] = 0;
        end
        memory1[0] = 32'hffffffff;
        memory1[1] = 32'hfffffff0;
        memory1[2] = 32'hffffff00;
    end
    assign instr_readdata = memory1[instr_address[29:0]];

    // reg [31:0] memory1 [16777215:0];
    // reg [31:0] memory2 [16777215:0];
    // reg [31:0] memory3 [16777215:0];
    // reg [31:0] memory4 [16777215:0];

    // initial begin
    //     integer i;
    //     for (i = 0; i < 65536; i++) begin
    //         memory1[i] = 0;
    //         memory2[i] = 0;
    //     end
    //     memory1[0] = 32'hffffffff;
    //     memory1[1] = 32'hfffffff0;
    //     memory1[2] = 32'hffffff00;
    //     memory2[0] = 32'hf;
    //     memory2[1] = 32'hff;
    //     memory2[2] = 32'hfff;
    // end

    // always @(*) begin
    //     if (instr_address[31:30] == 0) begin
    //         assign instr_readdata = memory1[instr_address[29:0]];
    //     end
    //     else if (instr_address[31:30] == 1) begin
    //         assign instr_readdata = memory2[instr_address[29:0]];
    //     end
    //     else if (instr_address[31:30] == 2) begin
    //         assign instr_readdata = memory3[instr_address[29:0]];
    //     end
    //     else begin
    //         assign instr_readdata = memory4[instr_address[29:0]];
    //     end        
    // end

endmodule