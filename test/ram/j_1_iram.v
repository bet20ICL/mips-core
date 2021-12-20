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
                // r2 -> 32'h1FFFFFFC
                opcode = 6'b100011;     
                rs = 0;
                rt = 2;
                imm = 16'h0;
                instr_readdata = {opcode, rs, rt, imm}; 
            end
            32'hBFC00004: begin
                // jr r2   
                opcode = 6'b0;
                rs = 5'd2;
                rt = 5'd0;
                rd = 5'd0;
                shamt = 5'd0;
                funct = 6'b001000;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'hBFC00008: begin
                instr_readdata = 0;
            end
            32'hBFC0000C: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hBFC00010: begin
                instr_readdata = 0;
            end
            32'h1FFFFFFC: begin
                // j 1C0
                // jumps to h2F00F000
                opcode = 6'b000010;     
                j_addr = 26'h3C03C00;
                instr_readdata = {opcode, j_addr};
            end
            32'h20000000: begin
                instr_readdata = 0;
            end
            32'h20000004: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h20000008: begin
                instr_readdata = 0;
            end
            32'h2F00F000: begin
                // j 380
                // jumps to h2FFFFFFC
                opcode = 6'b000010;     
                j_addr = 26'h3FFFFFF;
                instr_readdata = {opcode, j_addr};
            end
            32'h2F00F004: begin
                instr_readdata = 0;
            end
            32'h2F00F008: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h2F00F00C: begin
                instr_readdata = 0;
            end
            32'h2FFFFFFC: begin
                // j 380
                // jumps to 3ABC DEF0
                opcode = 6'b000010;     
                j_addr = 26'hEAF37BC;
                instr_readdata = {opcode, j_addr};
            end
            32'h30000000: begin
                instr_readdata = 0;
            end
            32'h30000004: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h30000008: begin
                instr_readdata = 0;
            end
            32'h3ABCDEF0: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 0;
                imm = 16'h100;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'h3ABCDEF4: begin
                instr_readdata = 0;
            end
            32'h3ABCDEF8: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h3ABCDEFC: begin
                instr_readdata = 0;
            end
        endcase
    end

endmodule