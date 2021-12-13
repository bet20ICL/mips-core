module reg_b(
    input logic b_write
    input logic[31:0] regout,
    output logic[31:0] bout
);

    reg[31:0] regb;

    always_comb begin
        if(a_write) begin
            regb = regout;
        end
    end

    assign bout = regb;

endmodule