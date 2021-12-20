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
                // lw r2, 0(r0)
                // r2 -> 32'h1FFFFFFC
                opcode = 6'b100011;     
                rs = 0;
                rt = 5'd20;
                imm = 16'h4;
                instr_readdata = {opcode, rs, rt, imm}; 
            end
            32'hBFC00008: begin
                // lw r2, 0(r0)
                // r2 -> 32'hFFFFFFFC
                opcode = 6'b100011;     
                rs = 0;
                rt = 5'd30;
                imm = 16'h8;
                instr_readdata = {opcode, rs, rt, imm}; 
            end
            32'hBFC0000C: begin
                // jalr r2   
                opcode = 6'b0;
                rs = 5'd2;
                rt = 5'd0;
                rd = 5'd3;
                shamt = 5'd0;
                funct = 6'b001001;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'hBFC00010: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 3;
                imm = 16'h200;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hBFC00014: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hBFC00018: begin
                instr_readdata = 0;
            end
            32'hAAAAAAA0: begin
                // jalr r2   
                opcode = 6'b0;
                rs = 5'd20;
                rt = 5'd0;
                rd = 5'd21;
                shamt = 5'd0;
                funct = 6'b001001;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'hAAAAAAA4: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 21;
                imm = 16'h204;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hAAAAAAA8: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hAAAAAAAC: begin
                instr_readdata = 0;
            end
            32'hBBBBBBB4: begin
                // jr r0    halt after running next instruction
                // jalr r2   
                opcode = 6'b0;
                rs = 5'd30;
                rt = 5'd0;
                rd = 5'd31;
                shamt = 5'd0;
                funct = 6'b001001;
                instr_readdata = {opcode, rs, rt, rd, shamt, funct};
            end
            32'hBBBBBBB8: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 31;
                imm = 16'h208;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hBBBBBBBC: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hBBBBBBC0: begin
                instr_readdata = 0;
            end
            32'hFFFFFFF0: begin
                // sw
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 0;
                imm = 16'h100;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'hFFFFFFF4: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'hFFFFFFF8: begin
                instr_readdata = 0;
            end
        endcase
    end

endmodule