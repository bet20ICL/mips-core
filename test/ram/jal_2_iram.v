module beq_4_iram(
    /* Combinatorial read access to instructions */
    input logic[31:0]  instr_address,
    output logic[31:0]   instr_readdata
);

    logic [5:0] i;

    // instantiate variables for easier instruction building
    // i-type 
    logic [5:0] opcode;
    logic [4:0] rt;
    logic [4:0] rs;
    logic [15:0] imm;
    logic [31:0] imm_instr;
    assign imm_instr = {opcode, rs, rt, imm};

    // r-type
    logic [4:0] rd; 
    logic [4:0] shamt;
    logic[14:0] ze;
    logic [5:0] funct;
    logic [31:0] r_instr;
    assign r_instr = {opcode, rs, rt, rd, shamt, funct};
    
    // j-type
    logic [25:0] j_addr;
    logic [31:0] j_instr;
    assign j_instr = {opcode, j_addr};
    
    always @(*) begin
        case (instr_address)
            32'hBFC00000: begin
                // lw r2, 0(r0)
                // r2 -> 32'h10000000
                opcode = 6'b100011;     
                rs = 0;
                rt = 2;
                imm = 16'h0;
                instr_readdata = {opcode, rs, rt, imm}; 
            end
            32'hBFC00004: begin
                // lw r3, 4(r0)
                // r2 -> 32'h10000000
                opcode = 6'b100011;     
                rs = 0;
                rt = 3;
                imm = 16'h4;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hBFC00008: begin
                // jal 1C0
                // jumps to BFC000700
                opcode = 6'b000011;     
                j_addr = 26'h1C0;
                instr_readdata = {opcode, j_addr};
            end
            32'hBFC0000C: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h200;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hBFC00010: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hBFC00014: begin
                instr_readdata = 0;
            end
            32'hB0000700: begin
                // jal 1C0
                // jumps to hB0000A00
                opcode = 6'b000011;     
                j_addr = 26'h280;
                instr_readdata = {opcode, j_addr};
            end
            32'hB0000704: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h204;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hB0000708: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hB000070C: begin
                instr_readdata = 0;
            end
            32'hB0000A00: begin
                // jal 380
                // jumps to BFC000700
                opcode = 6'b000011;     
                j_addr = 26'h3F00380;
                instr_readdata = {opcode, j_addr};
            end
            32'hB0000A04: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h208;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hB0000A08: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hB0000A0C: begin
                instr_readdata = 0;
            end
            32'hBFC00E00: begin
                // jr r2   
                opcode = 6'b0;
                rs = 5'd2;
                rt = 5'd0;
                rd = 5'd0;
                shamt = 5'd0;
                funct = 6'b001000;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'hBFC00E04: begin
                instr_readdata = 0;
            end
            32'hBFC00E08: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hBFC00E0C: begin
                instr_readdata = 0;
            end
            32'h10000000: begin
                // jal 41c0
                // jumps to BFC000700
                opcode = 6'b000011;     
                j_addr = 26'h41C0;
                instr_readdata = {opcode, j_addr};
            end
            32'h10000004: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h20C;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'h10000008: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h1000000C: begin
                instr_readdata = 0;
            end
            32'h10010700: begin
                // jal 3c00380
                // jumps to BFC000700
                opcode = 6'b000011;     
                j_addr = 26'h3C00380;
                instr_readdata = {opcode, j_addr};
            end
            32'h10010704: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h210;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'h10010708: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h1001070C: begin
                instr_readdata = 0;
            end
            32'h1F000E00: begin
                // jr r3    halt after running next instruction
                opcode = 6'b0;
                rs = 5'd3;
                rt = 5'd0;
                rd = 5'd0;
                shamt = 5'd0;
                funct = 6'b001000;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'h1F000E04: begin
                instr_readdata = 0;
            end
            32'h1F000E08: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h1F000E0C: begin
                instr_readdata = 0;
            end
            32'hF0000000: begin
                // jal 380
                // jumps to BFC000700
                opcode = 6'b000011;     
                j_addr = 26'h3FFC000;
                instr_readdata = {opcode, j_addr};
            end
            32'hF0000004: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 5'd31;
                imm = 16'h214;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hF0000008: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hF000000C: begin
                instr_readdata = 0;
            end
            32'hFFFF0000: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 0;
                imm = 16'h100;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hFFFF0004: begin
                instr_readdata = 0;
            end
            32'hFFFF0008: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hFFFF000C: begin
                instr_readdata = 0;
            end
        endcase
    end

endmodule