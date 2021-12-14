module addiu_iram(
    /* Combinatorial read access to instructions */
    input logic[31:0]  instr_address,
    output logic[31:0]   instr_readdata
);

    reg [31:0] instr_ram [0:4095];
    
    logic [31:0] word_address;
    assign word_address = instr_address >> 2;
    
    logic [5:0] i;
    initial begin
        for (i = 0; i < 4; i++) begin
            instr_ram[i] = i + 1; 
        end
    end

    always @(*) begin
        instr_readdata = instr_ram[instr_address];
    end

endmodule