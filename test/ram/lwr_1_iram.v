module lwr_1_iram(
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
    
    initial begin
        // memorry location 0x0: last instruction before halt 
        // memory locations 0x4: instruction memory starts here

        w_addr = 32'h0;

        // addiu r2, ABCD(r0)   r2 -> 0xFFFFFFFF  
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'hFFFF;
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // addiu r3, r0,1000110010110011 // r3  = 11111111111111111000110010110011
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 5'd3;
        imm = 16'b1000110010110011;
        // w_addr shifted right by 2 bits to save space
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // addiu r4, r0,100 // r4  = 100
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 5'd4;
        imm = 16'd100;
        // w_addr shifted right by 2 bits to save space
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // lwr r2, 2(r0)    r2 -> 0xffbbbbcc
        opcode = 6'b100110;
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'd2;
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // lwr r3, 0(r4)    r3 -> 10010110111100001000110010110011
        opcode = 6'b100110;
        rs = 5'd4;
        rt = 5'd3;
        imm = 16'd0;
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // sw r2, 16(r0) // MEM[16] = r2
        opcode = 6'b101011;     
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'd16;
        instr_ram[w_addr >> 2] = imm_instr; 
        w_addr += 4;

        // sw r3, 20(r0) // MEM[20] = r3
        opcode = 6'b101011;     
        rs = 5'd0;
        rt = 5'd3;
        imm = 16'd20;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // jr r0    halt after running next instruction
        opcode = 6'b0;
        rs = 5'd0;
        rt = 5'd0;
        rd = 5'd0;
        shamt = 5'd0;
        funct = 6'b001000;
        instr_ram[w_addr >> 2] = r_instr; 
        
        w_addr += 4;
        // nop
        instr_ram[w_addr >> 2] = 0; 

    end

    always_comb begin
        instr_readdata = instr_ram[inst >> 2];
    end

endmodule