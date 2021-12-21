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
    
    initial begin
        //$display("Instruction RAM contents");
        // memorry location 0x0: first instruction in program, last instruction before halt
        
        // w_addr is the address where the instruction will be stored
        w_addr = 32'h0;
        // addiu r10, r0,1000 // r10  = 1000
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 10;
        imm = 16'd1000;
        // w_addr shifted right by 2 bits to save space
        instr_ram[w_addr >> 2] = imm_instr; 

        // increment w_addr by 4 to store the next instruction
        w_addr += 4;
        // addiu r11, r0,10 // r11 = 10
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 11;
        imm = 16'd10;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // lb r2, 8(r0) // r2 = MEM[8]
        opcode = 6'b100101;     
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'd8;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // lb r3, -1(r11) // r3 = MEM[9]
        opcode = 6'b100101;     
        rs = 5'd10;
        rt = 5'd3;
        imm = -990;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // sw r2, -988(r10) // MEM[12] = r2
        opcode = 6'b101011;     
        rs = 5'd10;
        rt = 5'd2;
        imm = -988;
        instr_ram[w_addr >> 2] = imm_instr; 

        w_addr += 4;
        // sw r2, -988(r10) // MEM[12] = r2
        opcode = 6'b101011;     
        rs = 5'd11;
        rt = 5'd3;
        imm = 6;
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