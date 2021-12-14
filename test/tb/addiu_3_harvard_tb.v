module addiu_tb();

    logic     clk;
    logic     reset;
    logic    active;
    logic[31:0] register_v0;

    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    

    initial begin
        clk = 0;
        #4;
        repeat (1000) begin
            clk = ~clk;
            #4;
        end;
    end

    // variables to generate instruction word
    logic [31:0] w_addr;
    logic [5:0] i;

    // instantiate variables for easier instruction building
    // i-type 
    logic [5:0] opcode;
    logic [4:0] rt;
    logic [4:0] rs;
    logic [15:0] imm;
    logic [31:0] imm_instr;

    // r-type
    logic [4:0] rd; 
    logic [4:0] shamt;
    logic [5:0] funct;
    logic [31:0] r_instr;
    
    // j-type
    logic [25:0] j_addr;
    logic [31:0] j_instr;

    // logic [31:0] test;
    // logic [15:0] test_imm;
    // logic [31:0] next_test;
    
    // logic [31:0] curr_addr;
    // logic [31:0] tmp;
    // logic [31:0] link_addr;
    // logic[17:0] b_imm;
    // logic[31:0] b_offset;

    assign imm_instr = {opcode, rs, rt, imm};
    assign r_instr = {opcode, rs, rt, rd, shamt, funct};
    assign j_instr = {opcode, j_addr};

    // memorry location 0x0: last instruction
    // memory locations 0x4 - 0x3FF: instruction memory
    // memory locations 0x400 onwards: data memory

    // initialise data memory
    // set addresses 0x400 - 0x478 (30 locations) to a arithmetic series
    // inital value 32'h12345678 and difference 32'hdcba1234

    i = 0;
    w_addr = 32'h400;
    repeat (30) begin
        ram[w_addr] = 32'h12345678 + i * 32'hdcba1234;
        w_addr += 4;
        i += 1;
    end

    i = 2;
    w_addr = 32'h4;
    repeat (30) begin
        // lw ri 0(0)   load arithemtic series into registers 2 - 31
        opcode = 6'b100011;
        rs = 5'b0;
        rt = i;
        imm = 16'b0;
        ram[w_addr] = imm_instr; 
        w_addr += 4;
        i += 1;
    end

    i = 2;
    repeat (30) begin
        // addiu ri ri imm    add 0x11111111 * i to ri
        opcode = 6'b100011;
        rs = i;
        rt = i;
        imm = 16'h1111 * (i - 2);
        ram[w_addr] = imm_instr; 
        w_addr += 4;
        i += 1;
    end

    i = 2;
    repeat (30) begin
        // sw ri 0x480(r0)    store the results of the addiu instructiosn into location 0x480 and onwards
        opcode = 6'b101011;
        rs = 5'b0;
        rt = i;
        imm = 16'h1111 * (i - 2);
        ram[w_addr] = imm_instr; 
        w_addr += 4;
    end

    
    initial begin
        reset = 1;

        @(posedge clk);
        #2; // hold time
        assert(active == 1) else $fatal("Active not high after reset");
        reset = 0;

        while (active == 1) begin
            @(posedge clk);
            #2;
        end
    end

    mips_cpu_bus dut(
        .clk(clk),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );

    addiu_bus_tb_ram dut(
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );

endmodule

// 12345678
// eeee68ac
// cba87ae0
// a8628d14
// 851c9f48
// 61d6b17c
// 3e90c3b0
// 1b4ad5e4
// f804e818
// d4befa4c
// b1790c80
// 8e331eb4
// 6aed30e8
// 47a7431c
// 24615550
// 011b6784
// ddd579b8
// ba8f8bec
// 97499e20
// 7403b054
// 50bdc288
// 2d77d4bc
// 0a31e6f0
// e6ebf924
// c3a60b58
// a0601d8c
// 7d1a2fc0
// 59d441f4
// 368e5428
// 1348665c