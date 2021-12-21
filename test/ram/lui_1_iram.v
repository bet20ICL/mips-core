module lui_1_iram(
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
        //$display("Instruction RAM contents");
        // memorry location 0x0: first instruction in program, last instruction before halt
        
        // w_addr is the address where the instruction will be stored
        w_addr = 32'h0;
        // addiu r10, r0,1000 // r10  = 1000
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 5'd10;
        imm = 16'd1000;
        // w_addr shifted right by 2 bits to save space
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // lui r8, 16'h1354 // r8 = 32'h13540000
        opcode = 6'b001111;
        rs = 5'd0;
        rt = 5'd8;
        imm = 16'h1354;
        instr_ram[w_addr >> 2] = imm_instr;

        w_addr += 4;
        // lui r6, 2^16-1 // r6 = 32'hFFFF0000
        opcode = 6'b001111;
        rs = 5'd0;
        rt = 5'd6;
        imm = 16'hFFFF;
        instr_ram[w_addr >> 2] = imm_instr;

        w_addr += 4;
        // lui r12, 3 // r12 = 
        opcode = 6'b001111;
        rs = 5'd0;
        rt = 5'd12;
        imm = 16'd3;
        instr_ram[w_addr >> 2] = imm_instr;

        w_addr += 4;
        // lui r9, 0 // r9 = 32'h00000000
        opcode = 6'b001111;
        rs = 5'd0;
        rt = 5'd9;
        imm = 16'd0;
        instr_ram[w_addr >> 2] = imm_instr;

        w_addr += 4;
        // sw r8, -988(r10) // MEM[12] = r8
        opcode = 6'b101011;     
        rs = 5'd10;
        rt = 5'd8;
        imm = -988;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // sw r6, -984(r10) // MEM[16] = r6
        opcode = 6'b101011;     
        rs = 5'd10;
        rt = 5'd6;
        imm = -984;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // sw r12, -980(r10) // MEM[20] = r12
        opcode = 6'b101011;     
        rs = 5'd10;
        rt = 5'd12;
        imm = -980;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // sw r9, -976(r10) // MEM[24] = r9
        opcode = 6'b101011;     
        rs = 5'd10;
        rt = 5'd9;
        imm = -976;
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

        // $display("Instruction RAM Contents");
        // w_addr = 0;
        // repeat (200) begin
        //     $display("mem[%h] = %b", w_addr, instr_ram[w_addr >> 2]);
        //     w_addr += 4;
        // end
    end

    always @(*) begin
        if (instr_address[31:16] == 16'hBFC0) begin
            instr_readdata = instr_ram[inst >> 2];
        end
        else if(instr_address == 32'h0) begin
            instr_readdata = 32'h0; //mem[0x0] = nop;
        end
    end

endmodule