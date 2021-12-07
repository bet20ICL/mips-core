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

    assign instword = {word,funct};

    initial begin


        word = 0;
        funct = 6'b100001;
        rs = 32'd5;
        rt = 32'd10;
        #1;
        $display("unsigned result = %d", result);
        $display("signed result = %d", $signed(result));

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
