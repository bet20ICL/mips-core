module alu(
    input logic[3:0] control,
    input logic[31:0] op1,
    input logic[31:0] op2,
    output logic[31:0] result,
    output logic z_flag
);

    assign z_flag = (result == 0);
    
    always @(control, op1, op2) begin
        case (control)
            0: result <= op1 & op2;
            1: result <= op1 | op2;
            2: result <= op1 + op2;
            6: result <= op1 - op2;
            7: result <= op1 < op2 ? 1:0;
            12: result <= ~(op1 | op2);
            default: result <= 0;
        endcase
    end

endmodule
