module load_block(
    input logic[31:0] address,
    input logic[31:0] instr_word,
    input logic[31:0] datafromMem,
    output logic[31:0] out_transformed   
);

    logic[5:0] opcode;
    assign opcode = instr_word[31:26];

    //first need to code the byte enable

    // address % 4 should give the remainder which tells us which byte

    logic[1:0] whichbyte;

    assign whichbyte = address[1:0];

    always @(*) begin
        case(opcode) 
            35: out_transformed = {datafromMem[7:0],datafromMem[15:8],datafromMem[23:16],datafromMem[31:24]}; // LW
            // LB 100000
            32: case(whichbyte) // 0x12345678
                                //   3 2 1 0
                    3: out_transformed = {{24{datafromMem[7]}}, datafromMem[7:0]}; // sign extend x24
                    2: out_transformed = {{24{datafromMem[15]}},datafromMem[15:8]}; // sign extenstion 16 bits, BYTE, 0 x8 bits
                    1: out_transformed = {{24{datafromMem[23]}},datafromMem[23:16]}; // sign extension 8 bits, Byte, 16 zeros
                    0: out_transformed = {{24{datafromMem[31]}},datafromMem[31:24]}; //byte, 24 zeros
                endcase
            // LBU 100100
            36: case(whichbyte)
                    3: out_transformed = {24'h000000, datafromMem[7:0]}; // zero extend x24_
                    2: out_transformed = {24'h000000, datafromMem[15:8]}; // 0 extenstion 16 bits, BYTE, 0 x8 bits
                    1: out_transformed = {24'h000000, datafromMem[23:16]}; // 0 extension 8 bits, Byte, 16 zeros
                    0: out_transformed = {24'h000000, datafromMem[31:24]}; //byte, 24 zeros
                endcase

            // LH 100001
            33: case(whichbyte)
                    2: out_transformed = {{16{datafromMem[15]}},datafromMem[15:0]};
                    0: out_transformed = {{16{datafromMem[15]}},datafromMem[31:16]};
                endcase
            
            // LHU 100101
            37: case(whichbyte)
                    2: out_transformed = {16'h0000,datafromMem[15:0]};
                    0: out_transformed = {16'h0000,datafromMem[31:16]};

                endcase
            
            // LUI 001111
            15: out_transformed = {instr_word[15:0],16'h0};
            
        endcase 
                
            // 38: // LWR 100110
            //     begin
            //         out_transformed = {16{0}}//
            //     end
            // 34: // LWL 100010
            //     begin
                    
            //     end
            
    end
endmodule