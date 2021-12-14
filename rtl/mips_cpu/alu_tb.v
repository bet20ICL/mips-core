module alu_tb();


    // //0000 00|00 000|0 0000 |0000 0|000 00|00 0000
    // //opcode   rs      rt      rd   shamt   funct

    // //0000 00|00 000|0 0000 |0000 0 000 00 00 0000
    // //opcode   rs      rt       immediate

    // logic [31:6] word;
    // logic [5:0] funct;
    // logic [31:0] instword;

    // logic [31:0] opA;
    // logic [31:0] opB;

    // logic [4:0] rs, rt;

    // logic [31:0] result;
    // logic [31:0] hi, lo;
    // logic bflag;
    // logic [5:0] opcode;
    // logic [15:0] imm;
    // logic [31:0] imm_instr;

    // initial begin

    //     opcode = 6'b1;
    //     rs = 5'b0;
    //     rt = 5'b1;
    //     imm = 16'b0; 
    //     imm_instr = {opcode, rs, rt, imm};
    //     instword = imm_instr;

    //     opA = 32'h12345678;
    //     opB = 32'h0; 
    //     #1;
    //     $display("bflag is %h", bflag);

    //     // opcode = 6'd9;
    //     // rs = 5'd3;
    //     // rt = 5'd2;
    //     // imm = -16'd2;
    //     // imm_instr = {opcode, rs, rt, imm};
    //     // $display("%b", imm_instr);
    //     // instword = imm_instr;   
    //     // opA = 32'd2;
    //     // opB = 32'd1000;
    //     // #1;
    //     // $display("-------------------------------------");
    //     // $display("%h",result);


    //     // word = 0;
    //     // funct = 6'b100000;
    //     // instword = {word,funct};
    //     // rs = -32'd500000000;
    //     // rt = 32'd1000;
    //     // #1;
    //     // $display("-------------------------------------");
    //     // $display("unsigned of result = %d", result);
    //     // $display("signed of result = %d", $signed(result));
    //     // $display("hi=%h, lo = %h", $signed(hi),$signed(lo));
    //     // $display("b flag is %b",bflag);

    //     /*      


    //     word = 0;
    //     funct = 6'b100100;
    //     instword = {word,funct};
    //     rs = 32'h33333333;
    //     0001
    //     0010
    //     rt = 32'h22222222;
    //     #1;
    //     $display("unsigned of result = %h", result);
    //     $display("signed of result = %h", $signed(result));
    //     $display("hi=%h, lo = %h", $signed(hi),$signed(lo));
    //     */
    // end
    // alu dut(
    //     .op1(opA),
    //     .op2(opB),
    //     .instructionword(instword),
    //     .result(result),
    //     .hi(hi),
    //     .lo(lo),
    //     .b_flag(bflag)
    //     );

endmodule
