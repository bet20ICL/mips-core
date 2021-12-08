module hl_reg(
    input logic clk,
    input logic enable,
    input logic reset,
    input logic [31:0] data_in,
    output logic [31:0] data_out
);

    logic[31:0] data;
    assign data_out = data;

    always_ff @(posedge clk) begin
        if (reset) begin
            data <= 32'd0;
        end
        else if(enable) begin
            data <= data_in;
        end
    end

endmodule