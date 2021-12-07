module alu(
    input logic[31:0] op1, // data from rs,
    input logic[31:0] op2, // data from rt,
    input logic[31:0] instructionword,
    output logic[31:0] result,hi,lo,
    output logic b_flag
    // // zero, carry, overflow, yesbranch
);
    logic [15:0] immediatedata = instructionword[15:0];
    logic [5:0] shamt = instructionword[10:6];
    logic signed [31:0] signed_result = 0;
    logic[31:0] signed sign_op1 = $signed(op1);
    logic[31:0] signed sign_op2 = $signed(op2);

    logic unsigned [31:0] unsigned_result = 0;
    logic[31:0] unsigned unsign_op1 = $unsigned(op1);
    logic[31:0] unsigned unsign_op2 = $unsigned(op2);

    logic[63:0] multresult;

    logic r_format, i_format, j_format;
    logic[5:0] opcode = instructionword[31:26];
    logic[5:0] funct = instructionword[5:0];

  
    
    /*
    logic ADDiu; // Add immediate unsigned (no overflow)
    logic ADDu; // Add unsigned (no overflow)
    logic AND; // Bitwise and
    logic ANDi; // Bitwise and immediate
    logic BEQ; // Branch on equal - ALL BRANCHES DONE AS SUBTRACT AND THEN CHECK Z FLAG
    logic BGEZ; // Branch on greater than or equal to zero 
    logic BGEZAL; // Branch on non-negative (>=0) and link
    logic BGTZ; // Branch on greater than zero
    logic BLEZ; // Branch on less than or equal to zero
    logic BLTZ; // Branch on less than zero
    logic BLTZAL; // Branch on less than zero and link
    logic BNE; // Branch on not equal
    logic DIV // Divide 
    logic DIVU // Divide unsigned

    logic J // Jump
    logic JALR // Jump and link register
    logic JAL // Jump and link
    logic JR // Jump register

    logic LB // Load byte
    logic LBU // Load byte unsigned
    logic LH // Load half-word
    logic LHU // Load half-word unsigned
    logic UI // Load upper immediate
    logic LW // Load word
    logic LWL // Load word left
    logic LWR // Load word right
    logic MTHI // Move to HI // should just add 0 with rd being hi location
    logic MTLO // Move to LO // add zero register, rd = lo register
    logic MULT // Multiply

    logic MULTU	// Multiply unsigned --> should be casted input to unsigned
    logic OR // Bitwise or
    logic ORI // Bitwise or immediate
    logic SH // Store half-word
    logic SLL // Shift left logical
    logic SLLV // Shift left logical variable
    logic SLT // Set on less than (signed)
    logic SLTI // Set on less than immediate (signed)
    logic SLTIU // Set on less than immediate unsigned
    logic SLTU // Set on less than unsigned
    logic SRA // Shift right arithmetic
    logic SRAV // Shift right arithmetic
    logic SRL // Shift right logical
    logic SRLV // Shift right logical variable
    logic SUBU // Subtract unsigned
    logic SW // Store word
    logic XOR // Bitwise exclusive or
    logic XORI // Bitwise exclusive or immediate
    */

    always @(opcode,funct, op1,op2) begin
        case(opcode)
            0: r_format <= 1; case(funct)
                    0: unsigned_result <= unsign_op2 << shamt;
                    2: unsigned_result <= unsign_op2 >> shamt;
                    3: unsigned_result <= unsign_op2 >>> shamt;
                    4: unsigned_result <= unsign_op2 << unsign_op1;
                    6: unsigned_result <= unsign_op2 >> unsign_op1;
                    7: unsigned_result <= unsign_op2 >>> unsign_op1;
                    24: begin
                            multresult <= sign_op1 * sign_op2; // multiplication
                            hi <= multresult[63:32];
                            lo <= multresult[31:0];
                        end 
                    25: begin
                            multresult <= unsign_op1 * unsign_op2;  // mult unsinged
                            hi <= multresult[63:32];
                            lo <= multresult[31:0];
                        end 
                    26:begin // divide
                            //signed_result <= sign_op1 / sign_op2;
                            hi <= sign_op1%sign_op2;
                            lo <= sign_op1/sign_op2;
                        end  
                    27: begin // divide unsigned
                            //unsigned_result <= unsign_op1 / unsign_op2; 
                            hi <= unsign_op1%unsign_op2;
                            lo <= unsign_op1/unsign_op2;
                        end 
                    16: unsigned_result <= hi;//MFHI
                    17: hi <= op1; //MTHI
                    18: unsigned_result <= lo;//MFLO
                    19: lo <= op1;//MTLO

                    32: signed_result <= sign_op1 + sign_op2;
                    33: unsigned_result <= unsign_op1 + unsign_op2 // addu
                    34: signed_result <= sign_op1 - sign_op2 ;
                    35: unsigned_result <= unsign_op1 - unsign_op2;//subu
                    36: unsigned_result <= unsign_op1 & unsign_op2;
                    37: unsigned_result <= unsign_op1 | unsign_op2;
                    38: unsigned_result <= unsign_op1 ^ unsign_op2; // xor
                    39: unsigned_result <= ~(unsign_op1 | unsign_op2); //nor
                    42: signed_result <= sign_op1 < sign_op2 ? 1:0; //set lt
                    43: unsigned_result <= unsign_op1 < unsign_op2 ? 1:0;  //set ltu

            1:  if(op1<0) begin//bltz
                    b_flag <= 1;
                end
                else begin
                    b_flag = 0;
                end
            4:  if(op1==op2) begin//beq
                    b_flag <= 1;
                end
                else begin
                    b_flag = 0;
                end
            5:  if(op1 != op2) begin//bne
                    b_flag <= 1;
                end
                else begin
                    b_flag = 0;
                end
            6:  if(op1<=0) begin// blez branch less than or equal to 0-
                    b_flag <= 1;
                end
                else begin
                    b_flag = 0;
                end
            7:  if(op1>0) begin// bgtz
                    b_flag <= 1;
                end
                else begin
                    b_flag = 0;
                end
            8: signed_result <= sign_op1 + immediatedata ;//addi;
            9: unsigned_result <= unsign_op1 + immediatedata;//addiu
    end

    assign z_flag = (unsigned_result == 0);
    /*
    always @(control, unsign_op1, unsign_op2) begin
        case (control)
            0: unsigned_result <= unsign_op1 & unsign_op2; // and
            1: unsigned_result <= unsign_op1 | unsign_op2; // or
            2: unsigned_result <= unsign_op1 + unsign_op2; // add
            3: unsigned_result <= unsign_op1 / unsign_op2; // divide
            4: unsigned_result <= unsign_op1 * unsign_op2; // multiply
            5: unsigned_result <= unsign_op2 << shamt; // sll, rd = rt << shamt
            6: unsigned_result <= unsign_op1 - unsign_op2; // subtract
            7: unsigned_result <= unsign_op1 < unsign_op2 ? 1:0; // set on less than
            8: unsigned_result <= unsign_op2 << unsign_op1; // sllv, rd = rt << rs
            9: unsigned_result <= unsign_op2 >> shamt; // srl, rd = rt >> shamt
            10: unsigned_result <= unsign_op2 >> unsign_op1; // srlv, rd = rt >> rs
            11: unsigned_result <= unsign_op1 ^ unsign_op2; // XOR
            12: unsigned_result <= ~(unsign_op1 | unsign_op2); // NOR
            default: unsigned_result <= 0;
        endcase
    end
    */

    if(unsigned_result != 0) begin
        result <= unsigned_result;
    end
    else if(signed_result != 0) begin
        result <= signed_result;
    end
endmodule