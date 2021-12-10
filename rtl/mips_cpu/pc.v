module pc (
    input logic clk,
    input logic[31:0] next_addr,
    input logic reset,
    input logic enable,
    output logic[31:0] curr_addr
);

    always @(posedge clk) begin
        if(reset) begin
            curr_addr <= 32'hBFC00000;
        end
        else begin
            if (enable) begin
                curr_addr <= next_addr;
            end
        end
    end

endmodule