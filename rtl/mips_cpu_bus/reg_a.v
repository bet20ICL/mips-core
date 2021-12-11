module reg_a(
    input logic a_write
    input logic[31:0] regout,
    output logic[31:0] aout
);

    reg[31:0] rega;

    always_comb begin
        if(a_write) begin
            rega = regout;
        end
    end

    assign aout = rega;

endmodule