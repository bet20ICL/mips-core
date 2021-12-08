module alu(
    input logic[31:0] op1, // data from rs,
    input logic[31:0] op2, // data from rt,
    input logic[31:0] instructionword,
    output logic[31:0] result,hi,lo,
    output logic b_flag
    // // zero, carry, overflow, yesbranch
);
    logic [5:0] opcode;
    assign opcode = instructionword[31:26];

    logic [5:0] funct;
    assign funct = instructionword[5:0];
    logic [15:0] simmediatedata, uimmediatedata;
    assign simmediatedata = instructionword[15:0] <<< 16;
    assign uimmediatedata = instructionword[15:0] << 16;
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

    logic[63:0] multresult;

    logic r_format, i_format, j_format;
    

    always @(opcode,funct, op1,op2) begin
        unsigned_result = 0;
        signed_result = 0;
        case(opcode)
            0:  begin
                    r_format = 1; 
                    case(funct)
                        0: unsigned_result = unsign_op2 << shamt;
                        2: unsigned_result = unsign_op2 >> shamt;
                        3: unsigned_result = unsign_op2 >>> shamt;
                        4: unsigned_result = unsign_op2 << unsign_op1;
                        6: unsigned_result = unsign_op2 >> unsign_op1;
                        7: unsigned_result = unsign_op2 >>> unsign_op1;
                        24: begin
                                multresult = sign_op1 * sign_op2; // multiplication WORKS
                                hi = multresult[63:32];
                                lo = multresult[31:0];
                            end 
                        25: begin
                                multresult = unsign_op1 * unsign_op2;  // mult unsinged WORKS
                                hi = multresult[63:32];
                                lo = multresult[31:0];
                            end 
                        26: begin // divide
                                //signed_result = sign_op1 / sign_op2;
                                hi = sign_op1%sign_op2;
                                lo = sign_op1/sign_op2;
                            end  
                        27: begin // divide unsigned
                                //unsigned_result = unsign_op1 / unsign_op2; 
                                hi = unsign_op1%unsign_op2;
                                lo = unsign_op1/unsign_op2;
                            end 
                        16: unsigned_result = hi;//MFHI
                        17: hi = op1; //MTHI
                        18: unsigned_result = lo;//MFLO
                        19: lo = op1;//MTLO
                        32: signed_result = sign_op1 + sign_op2;//sub
                        33: unsigned_result = unsign_op1 + unsign_op2; // addu
                        34: signed_result = sign_op1 - sign_op2; //sub
                        35: unsigned_result = unsign_op1 - unsign_op2;//subu
                        36: unsigned_result = unsign_op1 & unsign_op2;//and
                        37: unsigned_result = unsign_op1 | unsign_op2;//or
                        38: unsigned_result = unsign_op1 ^ unsign_op2; // xor
                        39: unsigned_result = ~(unsign_op1 | unsign_op2); //nor
                        42: signed_result = sign_op1 < sign_op2 ? 1:0; //set lt
                        43: unsigned_result = unsign_op1 < unsign_op2 ? 1:0;  //set ltu
                    endcase
                end
            1:  if(op1<0) begin//bltz
                    b_flag = 1;
                end
                else begin
                    b_flag = 0;
                end
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
            8: signed_result = sign_op1 + simmediatedata ;//addi;
            9: unsigned_result = unsign_op1 + simmediatedata;//addiu
            10: signed_result = (sign_op1<simmediatedata) ? 1:0;//slti
            11: unsigned_result = (unsign_op1<simmediatedata) ? 1:0; //sltiu
            12: unsigned_result = unsign_op1 & uimmediatedata;//andi
            13: unsigned_result = unsign_op1 | uimmediatedata;//ori
            14: unsigned_result = unsign_op1 ^ uimmediatedata; //XORI
            15: unsigned_result = uimmediatedata<<16;//lui
            32: unsigned_result = unsign_op1 + simmediatedata;//lb
            33: unsigned_result = unsign_op1 + simmediatedata;//lh
            34: unsigned_result = unsign_op1 + simmediatedata;//lw
            36: unsigned_result = unsign_op1 + simmediatedata;//lbu
            37: unsigned_result = unsign_op1 + simmediatedata;//lhu
            40: unsigned_result = unsign_op1 + simmediatedata;//sb
            41: unsigned_result = unsign_op1 + simmediatedata;//sh
            43: unsigned_result = unsign_op1 + simmediatedata;//sw
        endcase
        if(unsigned_result != 0) begin
            result = unsigned_result;
        end
        else if(signed_result != 0) begin
            result = signed_result;
        end
    end
endmodule