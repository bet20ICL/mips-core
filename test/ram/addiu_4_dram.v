module addiu_4_dram(
    /* Combinatorial read and single-cycle write access to data */
    input logic clk,
    input logic[31:0]  data_address,
    input logic        data_write,
    input logic        data_read,
    input logic[31:0]  data_writedata,
    output logic[31:0]  data_readdata
);

    reg [31:0] data_ram [0:4095];
    integer w_addr;
    logic[31:0] data_in;

    logic [5:0] i;
    initial begin
        // initialise data memory
        // set addresses 0x0 - 0x078 (30 locations) to a arithmetic series
        // inital value 32'h12345678 and difference 32'hdcba1234
        i = 0;
        w_addr = 32'h00;
        data_in = 32'h12345678 + i * 32'hdcba1234;
        data_ram[w_addr] = {data_in[7:0], data_in[15:8], data_in[23:16], data_in[31:24]};
        w_addr = w_addr + 4;
    end

    always_comb begin
        if (data_read) begin
            data_readdata = data_ram[data_address];
        end
    end

    always_ff @(posedge clk) begin
        if (data_write) begin
            data_ram[data_address] <= data_writedata;
        end
    end

endmodule