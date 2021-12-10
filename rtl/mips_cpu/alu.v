module alu(
    input logic[31:0] op1, // data from rs,
    input logic[31:0] op2, // data from rt,
    input logic[31:0] instructionword,
    output logic[31:0] result,
    output logic[31:0] hi,
    output logic[31:0] lo,
    output logic[31:0] memaddroffset,
    output logic b_flag
    // // zero, carry, overflow, yesbranch
);
    logic [5:0] opcode;
    assign opcode = instructionword[31:26];

    logic [5:0] funct;
    assign funct = instructionword[5:0];
    logic [31:0] ex_imm;
    assign ex_imm = {instructionword[15] ? 16'hFFFF : 16'h0, instructionword[15:0]};
    logic [5:0] shamt;
    assign shamt = instructionword[10:6];
    
    logic signed [31:0] signed_result;
    logic unsigned [31:0] unsigned_result;

    logic signed [31:0]  sign_op1;
    assign sign_op1 = $signed(op1);

    logic signed [31:0] sign_op2;
    assign sign_op2 = $signed(op2);

    logic unsigned [31:0] unsign_op1;
    assign unsign_op1  = $unsigned(op1);

    logic unsigned [31:0] unsign_op2;
    assign unsign_op2 = $unsigned(op2);

    logic [4:0] addr_rt;
    assign addr_rt = instructionword[20:16];

    logic[63:0] multresult;

    logic r_format, i_format, j_format;
    
    always @(opcode,funct, op1,op2) begin
        unsigned_result = 0;
        signed_result = 0;
        case(opcode)
            0:  begin
                    r_format = 1; 
                    case(funct)
                        0: unsigned_result = unsign_op2 << shamt; // out to rd |SLL
                        2: unsigned_result = unsign_op2 >> shamt;// out to rd |SRL
                        3: unsigned_result = unsign_op2 >>> shamt;// out to rd |SRA
                        4: unsigned_result = unsign_op2 << unsign_op1;// out to rd |SLLV
                        6: unsigned_result = unsign_op2 >> unsign_op1;// out to rd |SLRV
                        7: unsigned_result = unsign_op2 >>> unsign_op1;// out to rd |SRAV
                        24: begin
                                multresult = sign_op1 * sign_op2; // out to hi,lo |mult
                                hi = multresult[63:32];
                                lo = multresult[31:0];
                            end 
                        25: begin
                                multresult = unsign_op1 * unsign_op2;  // out to hi,lo |multu
                                hi = multresult[63:32];
                                lo = multresult[31:0];
                            end 
                        26: begin // out to hi,lo |div
                                //signed_result = sign_op1 / sign_op2;
                                hi = sign_op1%sign_op2;
                                lo = sign_op1/sign_op2;
                            end  
                        27: begin // out to hi,lo |divu
                                //unsigned_result = unsign_op1 / unsign_op2; 
                                hi = unsign_op1%unsign_op2;
                                lo = unsign_op1/unsign_op2;
                            end 
                        16: unsigned_result = hi;//out to rd |MFHI
                        17: hi = op1; //MTHI
                        18: unsigned_result = lo;//out to rd |MFLO
                        19: lo = op1;//MTLO
                        32: signed_result = sign_op1 + sign_op2;//out to rd |add
                        33: unsigned_result = unsign_op1 + unsign_op2; // out to rd |addu
                        34: signed_result = sign_op1 - sign_op2; //out to rd |sub
                        35: unsigned_result = unsign_op1 - unsign_op2;//out to rd |subu
                        36: unsigned_result = unsign_op1 & unsign_op2;//out to rd |and
                        37: unsigned_result = unsign_op1 | unsign_op2;//out to rd |or
                        38: unsigned_result = unsign_op1 ^ unsign_op2; // out to rd |xor
                        39: unsigned_result = ~(unsign_op1 | unsign_op2); //out to rd |nor
                        42: signed_result = sign_op1 < sign_op2 ? 1:0; //out to rd |set lt
                        43: unsigned_result = unsign_op1 < unsign_op2 ? 1:0;//out to rd |set ltu
                    endcase
                end
                // for branches, bflag is sent out, bflag = 1 when branching is valid | 'result' output should do nothing
                //bgez, bgezal, bltz, blez 
            1: case(addr_rt)
                    1:if(op1>=0) begin// //bgez
                        b_flag = 1;
                    end
                    else begin
                        b_flag = 0;
                    end
                    17:if(op1>=0) begin//bgezal
                        b_flag = 1;
                    end
                    else begin
                        b_flag = 0;
                    end
                    0:if(op1<0) begin//bltz
                        b_flag = 1;
                    end
                    else begin
                        b_flag = 0;
                    end
                    16:if(op1<0) begin//bltzal
                        b_flag = 1;
                    end
                    else begin
                        b_flag = 0;
                    end
               endcase

            4:  if(op1==op2) begin//beq
                    b_flag = 1;
                end
                else begin
                    b_flag = 0;
                end
            5:  if(op1 != op2) begin//bne
                    b_flag = 1;
                end
                else begin
                    b_flag = 0;
                end
            6:  if(op1<=0) begin// blez branch less than or equal to 0-
                    b_flag = 1;
                end
                else begin
                    b_flag = 0;
                end
            7:  if(op1>0) begin// bgtz
                    b_flag = 1;
                end
                else begin
                    b_flag = 0;
                end
            8: signed_result = sign_op1 + ex_imm ;//out to rt |addi;
            9: unsigned_result = unsign_op1 + ex_imm;//out to rt |addiu
            10: signed_result = (sign_op1 < ex_imm) ? 1:0;//out to rt |slti
            11: unsigned_result = (unsign_op1 < ex_imm) ? 1:0; //out to rt |sltiu
            12: unsigned_result = unsign_op1 & ex_imm;//out to rt |andi
            13: unsigned_result = unsign_op1 | ex_imm;//out to rt |ori
            14: unsigned_result = unsign_op1 ^ ex_imm; //out to rt |XORI
            15: unsigned_result = ex_imm << 16;//out to rt |lui
            //memory access instructions
            32: memaddroffset = unsign_op1 + ex_imm;//lb
            33: memaddroffset = unsign_op1 + ex_imm;//lh
            34: memaddroffset = unsign_op1 + ex_imm;//lw
            36: memaddroffset = unsign_op1 + ex_imm;//lbu
            37: memaddroffset = unsign_op1 + ex_imm;//lhu
            40: memaddroffset = unsign_op1 + ex_imm;//sb
            41: memaddroffset = unsign_op1 + ex_imm;//sh
            43: memaddroffset = unsign_op1 + ex_imm;//sw
        endcase
        if(unsigned_result != 0) begin
            result = unsigned_result;
        end
        else if(signed_result != 0) begin
            result = signed_result;
        end
    end
endmodule