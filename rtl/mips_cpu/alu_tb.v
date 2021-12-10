module alu_tb();
    
    
    // 0000 00|00 000|0 0000 |0000 0|000 00|00 0000
    // opcode   rs      rt      rd   shamt   funct

    // 0000 00|00 000|0 0000 |0000 0 000 00 00 0000
    // opcode   rs      rt       immediate

    logic [31:6] word;
    logic [5:0] funct;
    logic [31:0] instword;

    logic [31:0] rs;
    logic [31:0] rt;

    logic [31:0] result;
    logic [31:0] hi, lo;
    logic bflag;

    initial begin


        word = 0;
        funct = 6'b011000;
        instword = 32'b00010000000000000000000000000000;
        rs = 32'd1000;
        rt = 32'd1000;
        #1;
        $display("-------------------------------------");
        $display("b flag is %b",bflag);


        word = 0;
        funct = 6'b100000;
        instword = {word,funct};
        rs = -32'd500000000;
        rt = 32'd1000;
        #1;
        $display("-------------------------------------");
        $display("unsigned of result = %d", result);
        $display("signed of result = %d", $signed(result));
        $display("hi=%h, lo = %h", $signed(hi),$signed(lo));
        $display("b flag is %b",bflag);

/*      
        

        word = 0;
        funct = 6'b100100;
        instword = {word,funct};
        rs = 32'h33333333;
        // 0001
        // 0010
        rt = 32'h22222222;
        #1;
        $display("unsigned of result = %h", result);
        $display("signed of result = %h", $signed(result));
        $display("hi=%h, lo = %h", $signed(hi),$signed(lo));
*/
    end
    alu dut(
        .op1(rs),
        .op2(rt),
        .instructionword(instword),
        .result(result),
        .hi(hi),
        .lo(lo),
        .b_flag(bflag)
    );

endmodule
