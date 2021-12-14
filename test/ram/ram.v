module ram(
    input logic clk,
    input logic write,
    input logic read,
    input logic[31:0] addr,
    input logic[31:0] data_write,
    output logic[31:0] data
);

    reg[31:0] ram [0:6400];

    always_comb begin
        if (read) begin
            data = ram[addr];
        end
    end

    always_ff @(posedge clk) begin
        if (write) begin
            ram[addr] <= data_write;
        end
    end

endmodule