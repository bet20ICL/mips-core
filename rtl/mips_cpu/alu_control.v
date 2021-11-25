module alu_control(
    input logic[1:0] alu_opcode,
    input logic[5:0] alu_fcode,
    output logic [3:0] alu_control_out
);

    always @(*) begin
        if(alu_opcode == 0) begin
            alu_control_out = 2;
        end
        else if(alu_opcode==1) begin
            alu_control_out = 6;
        end
        else if(alu_opcode==2) begin
            case(alu_fcode)
                6'b100000 : alu_control_out = 4'b0010;
                6'b100010 : alu_control_out = 4'b0110;
                6'b100100 : alu_control_out = 4'b0000;
                6'b100101 : alu_control_out = 4'b0001;
                6'b101010 : alu_control_out = 4'b0111;
            endcase
        end
    end
endmodule