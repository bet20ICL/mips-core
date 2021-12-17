module sltiu_2_iram(
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
        i = 2;
        w_addr = 32'h0;
        repeat (30) begin
            // lw ri, (i-2) * 4 (r0)  
            // load arithmetic series into r2 - r16
            opcode = 6'b100011;     
            rs = 5'd0;
            rt = i;
            imm = (i - 2) * 4;
            instr_ram[w_addr>>2] = imm_instr; 
            //$display("mem[%h] = %b", w_addr >> 2, instr_ram[w_addr >> 2]);
            w_addr += 4;
            i += 1;
        end

        i = 2;
        repeat (30) begin
            // ori ri ri imm    add 0x11111111 * i to ri
            opcode = 6'b001011;
            rs = i;
            rt = i;
            imm = 16'h4000;
            instr_ram[w_addr>>2] = imm_instr; 
            w_addr += 4;
            i += 1;
        end

        i = 2;
        repeat (30) begin
            // sw ri 0x480(r0)    store the results of the addiu instructiosn into location 0x480 and onwards
            opcode = 6'b101011;
            rs = 5'b0;
            rt = i;
            imm = 16'h100 + (i-2)*4;
            instr_ram[w_addr>>2] = imm_instr; 
            w_addr += 4;
            i+=1;
            #2;
        end
        opcode = 6'b000000;
        rd = 0;
        ze = 0;
        funct = 6'b001000;
        instr_ram[w_addr] = r_instr;
    end

    always_comb begin
        instr_readdata = instr_ram[inst>>2];
    end

endmodule