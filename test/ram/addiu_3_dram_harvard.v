module addiu_dram(
    /* Combinatorial read and single-cycle write access to data */
    input logic clk,
    input logic[31:0]  data_address,
    input logic        data_write,
    input logic        data_read,
    input logic[31:0]  data_writedata,
    output logic[31:0]  data_readdata
);

    reg [31:0] data_ram [0:4095];
    assign word_address = data_address >> 2;

    initial begin
        
    end

    always @(*) begin
        if (data_read) begin
            data_readdata = data_ram[word_address];
        end
    end

    always_ff @(posedge clk) begin
        if (data_write) begin
            data_ram[word_address] <= data_writedata;
        end
    end

endmodule