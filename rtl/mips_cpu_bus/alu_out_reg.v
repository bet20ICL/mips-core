module alu_out_reg(
    input logic alu_out_write,
    input logic[31:0] alu_out_b4reg,
    output logic[31:0] alu_out
); 

reg[31:0] alu_out_reg;

always_comb begin
    if(alu_out_write) begin
        alu_out_reg = alu_out_b4reg;
    end
end

assign alu_out = alu_out_reg;


endmodule