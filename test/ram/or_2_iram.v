module or_2_iram(
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
        repeat (15) begin
            // lw ri, (i-2) * 4 (r0)  
            // load arithmetic series into r2 - r16
            opcode = 6'b100011;     
            rs = 5'd0;
            rt = i;
            imm = (i - 2) * 4;
            instr_ram[w_addr >> 2] = imm_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;
            i += 1;
        end

        i = 3;
        repeat (14) begin
            // or, i + 14, i - 1, i
            // bitwise or consecutive registers and store results in r17 - r30
            // or r17, r2, r3 | or r18, r3, r4 | etc.
            opcode = 6'b0;
            rs = i - 1;
            rt = i;
            rd = i + 14;
            shamt = 5'd0;
            funct = 6'b100101;
            instr_ram[w_addr >> 2] = r_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;
            i += 1;
        end

        i = 17;
        repeat (14) begin
            // sw ri, (i-2) * 4 (r0)  
            // store r17 - r30 to addresses 0x100 to 0x134
            opcode = 6'b101011;     
            rs = 5'd0;
            rt = i;
            imm = 16'h100 + (i - 17) * 4;
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

        // addiu r2, 0(r0)   nop
        opcode = 6'b001001;     
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'h0;
        instr_ram[w_addr >> 2] = imm_instr; 
        //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

    end

    always_comb begin
        instr_readdata = instr_ram[inst >> 2];
    end

endmodule