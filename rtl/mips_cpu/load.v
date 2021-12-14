module Load(
    //input logic[31:0] address,
    input logic[31:0] instr_word,
    input logic[31:0] datafromMem,
    input logic[31:0] datafromReg,

    output logic read,
    output logic write,
    
    //output logic[31:0] addr,
    output logic[31:0] out_transformed   
);

//first need to code the byte enable

// address % 4 should give the remainder which tells us which byte
logic[5:0] opcode = instr_word[31:26];
//logic[31:0] dummyread;

logic[2:0] whichbyte;

assign whichbyte = address % 4;


always@(*) begin
    case(opcode)
        43: out_transformed = datafromReg; // SW
        35: out_transformed = datafromMem; // LW
        32: begin // LB 100000
                case(whichbyte) // 0x12345678
                                //   3 2 1 0
                0: out_transformed = {24{datafromMem[7]}, datafromMem[7:0]} // sign extend x24
                1: out_transformed = {16{datafromMem[15]},datafromMem[15:7],8{0}}} // sign extenstion 16 bits, BYTE, 0 x8 bits
                2: out_transformed = {8{datafromMem[24]},datafromMem[23:16],16{0}} // sign extension 8 bits, Byte, 16 zeros
                3: out_transformed = {datafromMem[31:26],24{0}}; //byte, 24 zeros
            end
        36: // LBU 100100
            begin
                case(whichbyte)
                0: out_transformed = {24{0}, datafromMem[7:0]}; // zero extend x24
                1: out_transformed = {16{0},datafromMem[15:7],8{0}}}; // 0 extenstion 16 bits, BYTE, 0 x8 bits
                2: out_transformed = {8{0},datafromMem[23:16],16{0}}; // 0 extension 8 bits, Byte, 16 zeros
                3: out_transformed = {datafromMem[31:26],24{0}}; //byte, 24 zeros
            end
        33: // LH 100001
            begin
                out_transformed = {16{datafromMem[15]},datafromMem[15:0]};
            end
        37: // LHU 100101
            begin
                out_transformed = {16{0},datafromMem[15:0]};
            end
        15: // LUI 001111
            begin
                out_transformed = {instr_word[15:0],16{0}};
            end
        // 38: // LWR 100110
        //     begin
        //         out_transformed = {16{0}}//
        //     end
        // 34: // LWL 100010
        //     begin
                
        //     end
end

endmodule
 