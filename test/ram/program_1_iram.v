module program_1_iram(
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
        // 1| add t0 zero zero  
        // w_addr shifted right by 2 bits to save space
        instr_ram[w_addr >> 2] = 32'h00004020; 

        // increment w_addr by 4 to store the next instruction
        w_addr += 4;
        //  2| addi t1 zero 0x0001	
        instr_ram[w_addr >> 2] = 32'h20090001; 

        w_addr += 4;
        //  3| load t2 from DRAM[0]
        instr_ram[w_addr >> 2] =  32'h8C0A0000; 

        w_addr += 4;
        //  4| addi t2 t2 -1 
        instr_ram[w_addr >> 2] =  32'h214AFFFF; 

        w_addr += 4;
        //mov 4 into t4
        instr_ram[w_addr >> 2] = 32'h200C0004;
    
        w_addr += 4;
        // addu t3 t0 t1
        // loop begins
        instr_ram[w_addr >> 2] = 32'h01095821; 

        w_addr += 4;
        // sw t3 0x0000 t4
        instr_ram[w_addr >> 2] = 32'hAD8B0000; 

        w_addr += 4;
        // addiu t4 t4 0x0004
        instr_ram[w_addr >> 2] = 32'h258C0004; 

        w_addr += 4;
        // addu t0 zero t1
        instr_ram[w_addr >> 2] = 32'h00094021; 

        w_addr += 4;
        // addu t1 zero t3
        instr_ram[w_addr >> 2] = 32'h000B4821; 

        w_addr += 4;
        // addi t2 t2 0xFFFF
        instr_ram[w_addr >> 2] = 32'h214AFFFF;
        
        w_addr += 4;
        // bgtz t2 0xFFF9
        instr_ram[w_addr >> 2] = 32'h1D40FFF9; 

        w_addr += 4;
        // delay slot
        instr_ram[w_addr >> 2] = 32'd0; 

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