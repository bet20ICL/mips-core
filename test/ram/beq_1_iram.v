module beq_4_iram(
    /* Combinatorial read access to instructions */
    input logic[31:0]  instr_address,
    output logic[31:0]   instr_readdata
);

    reg [31:0] instr_ram [0:4095];

    logic[31:0] inst;

    assign inst = instr_address % (32'hBFC00000);
    
    // variables to generate instruction word
    logic[31:0] w_addr;
    // logic[31:0] w_addr_s;
    // assign w_addr_s = w_addr >> 2;
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

    // sw
    // stp
    // nop
    
    // lw r2, 0(r0) 
    // beq r2, r3, 
    
    always @(*) begin
        case (instr_address)
            32'hBFC00000: begin
                // lw r2    r2 -> h20000000
                opcode = 6'b100011;     
                rs = 5'd0;
                rt = 5'd2;
                imm = 0;
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
            32'h20000000: begin
                // beq r20, r25, -C0 0000
                opcode = 6'b000100;     
                rs = 20;
                rt = 25;
                imm = -256;
                instr_readdata = {opcode, rs, rt, imm}; 
            end
            32'h20000004: begin
                instr_readdata = 0;
            end
            32'h20000008: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h2000000C: begin
                instr_readdata = 0;
            end
            32'h1fffff04: begin
                // sw 0 100(r0)
                opcode = 6'b101011;     
                rs = 5'd0;
                rt = 0;
                imm = 16'h100;
                instr_readdata = {opcode, rs, rt, imm};
            end
            32'h1fffff08: begin
                // jr r0    halt after running next instruction
                funct = 6'b001000;
                instr_readdata = {26'h0, funct};
            end
            32'h1fffff0C: begin
                instr_readdata = 0;
            end
        endcase
    end

endmodule