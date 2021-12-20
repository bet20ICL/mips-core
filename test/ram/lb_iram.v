module lb_iram(
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

        // lb r2 , r0+ 10  [r0 = 0]
        opcode = 6'b100000;     
        rs = 5'd0;
        rt = 5'd2;
        imm = 16'10; 
        instr_ram[w_addr >> 2] = imm_instr; 
        $display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // sw r2,r0 + 11, 
        opcode = 6'b101011;
        rs = 5'd0;
        rt = 5'd2;
        imm = 11;
        instr_ram[w_addr >> 2] = imm_instr; 
        $display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;

        // jr r0    halt after running next instruction
        opcode = 6'b0;
        rs = 5'd0;
        rt = 5'd0;
        rd = 5'd0;
        shamt = 5'd0;
        funct = 6'b001000;
        instr_ram[w_addr >> 2] = r_instr; 
        $display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;


        opcode = 6'b0;
        rs = 5'd0;
        rt = 5'd0;
        rd = 5'd0;
        shamt = 5'd0;
        funct = 6'b000000;
        instr_ram[w_addr >> 2] = r_instr; 
        $display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
        w_addr += 4;


    end

    always_comb begin
        instr_readdata = instr_ram[inst >> 2];
    end