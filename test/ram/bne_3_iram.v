module bne_3_iram(
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
        w_addr = 32'h0;

        i = 2;
        repeat (30) begin
            // lw ri, (i-2) * 4 (r0)  
            // load different into r2 - r31
            opcode = 6'b100011;     
            rs = 5'd0;
            rt = i;
            imm = (i - 2) * 4;
            instr_ram[w_addr >> 2] = imm_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;
            i += 1;
        end

        i = 2;
        repeat (29) begin
            // beq i, i + 1, 2
            // jump 2 instructions ahead if two consecutive registers are equal
            // jump to next beq instruction
            // beq r2, r3, 2 | beq r3, r4, 2 | etc.
            // registers should not be equal so program should not branch
            opcode = 6'b000101;     
            rs = i;
            rt = i + 1;
            imm = 2;
            instr_ram[w_addr >> 2] = imm_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;

            // nop
            instr_ram[w_addr >> 2] = 32'h0; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;

            // sw ri, (100 + i)(r0)
            // store r17 - r30 to addresses 0x100 to 0x1
            opcode = 6'b101011;     
            rs = 5'd0;
            rt = i;
            imm = 16'h100 + (i - 2) * 4;
            instr_ram[w_addr >> 2] = imm_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;
            i += 1;
        end

        // jr r0    halt after running next instruction
        opcode = 6'b0;
        rs = 5'd0;
        rt = 5'd0;
        rd = 5'd0;
        shamt = 5'd0;
        funct = 6'b001000;
        instr_ram[w_addr >> 2] = r_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // nop
        instr_ram[w_addr >> 2] = 0; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // $display("Instruction RAM Contents");
        // w_addr = 0;
        // repeat (200) begin
        //     $display("mem[%h] = %b", w_addr, instr_ram[w_addr >> 2]);
        //     w_addr += 4;
        // end
    end

    always_comb begin
        instr_readdata = instr_ram[inst >> 2];
    end

endmodule