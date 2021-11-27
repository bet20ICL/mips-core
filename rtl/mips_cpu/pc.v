module pc (
    input logic clk,
    input logic[31:0] next_addr,
    input logic reset,
    output logic[31:0] curr_addr
);
    
    always @(posedge clk) begin
        curr_addr <= next_addr;
    end

endmodule