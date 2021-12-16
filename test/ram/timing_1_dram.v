module timing_1_dram(
    /* Combinatorial read and single-cycle write access to data */
    input logic clk,
    input logic[31:0]  data_address,
    input logic        data_write,
    input logic        data_read,
    input logic[31:0]  data_writedata,
    output logic[31:0]  data_readdata
);

    reg [31:0] data_ram [0:4095];

    logic [31:0] data_addr_s;
    assign data_addr_s = data_address >> 2;

    logic[31:0] w_addr;
    logic[31:0] w_addr_s;
    assign w_addr_s = w_addr >> 2;

    logic [5:0] i;
    initial begin
        // initialise data memory
        i = 0;
        w_addr = 32'h480;
        data_ram[w_addr_s] = 32'h12345678;
        w_addr += 4;
    end

    always_comb begin
        if (data_read) begin
            data_readdata = data_ram[data_addr_s];
        end
    end

    always_ff @(posedge clk) begin
        if (data_write) begin
            data_ram[data_addr_s] <= data_writedata;
        end
    end

endmodule