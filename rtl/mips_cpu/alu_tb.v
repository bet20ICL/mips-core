module alu_tb();
    
    
    // 0000 00|00 000|0 0000 |0000 0|000 00|00 0000
    // opcode   rs      rt      rd   shamt   funct

    // 0000 00|00 000|0 0000 |0000 0 000 00 00 0000
    // opcode   rs      rt       immediate

    logic [31:6] word;
    logic [5:0] funct;
    logic[4:0] sa;
    logic [31:0] instword;

    logic[4:0] rsaddr,rtaddr,rdaddr;
    logic[5:0] opcode;
    logic[15:0] immediate;

    logic [31:0] rs;
    logic [31:0] rt;

    logic [31:0] result;
    logic [31:0] hi, lo, offset;
    logic bflag;

    initial begin


        //lets just say rs and rt are stored at reg 2,3
        opcode = 6'b001001;
        funct = 6'b100110;  
        sa = 0;
        rsaddr = 5'b00000;

        rtaddr = 5'b00000; // change for branches

        
        rs = 61;
        rt = 1; // can be whatever since its value of rt isnt being used.

        immediate = -11; 

        if(opcode == 0) begin
                instword = {opcode,rsaddr,rtaddr,rdaddr,sa,funct};
        end
        else begin
            instword = {opcode,rsaddr,rtaddr,immediate};
        end  

    
    
        #1;

        //$display("hi = %b",hi);
        //$display("low = %b",lo);
        $display("result = %d",result);
        //$display("offset= %d",offset);


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
        .memaddroffset(offset),
        .b_flag(bflag)
    );

endmodule
