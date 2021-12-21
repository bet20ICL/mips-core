module lwl_1_tb ();

    logic clk;
    logic     reset;
    logic    active;
    logic[31:0] register_v0;

    /* New clock enable. See below. */
    logic     clk_enable;

    /* Combinatorial read access to instructions */
    logic[31:0]  instr_address;
    logic[31:0]  instr_readdata;

    /* Combinatorial read and single-cycle write access to instructions */
    logic[31:0]  data_address, data_address_wanted;
    logic        data_write;
    logic        data_read;
    logic[31:0]  data_writedata;
    logic[31:0]  data_readdata;

    logic[5:0] i;
    logic[31:0] exp_val;

    logic read, tb_read;
    logic [31:0] addr, tb_addr;
    logic [31:0] tmp;

    function [31:0] reverse_endian;
        input [31:0] a;
        begin
            logic [31:0] tmp;
            tmp[7:0] = a[31:24];
            tmp[15:8] = a[23:16];
            tmp[23:16] = a[15:8];
            tmp[31:24] = a[7:0];
            reverse_endian = tmp; 
        end
    endfunction

    initial begin
        clk = 0;
        #4;
        repeat (10000) begin
            clk = ~clk;
            #4;
        end
        $fatal(2, "too long");
    end

    logic [31:0] test_addr;
    logic [31:0] undefined;

    initial begin
        // tb_read: set to 0 to connect data ram to cpu, set to 1 to connect to testbench
        tb_read=0;
        // required for cpu to run
        clk_enable = 1;
        reset = 1;
        @(posedge clk);
        #2;

        reset = 0;
        @(posedge clk);
        #2;

        // wait until active goes low, signalling halt
        while (active) begin
            @(posedge clk);
            #2;
        end

        @(posedge clk);

        // start checking data ram
        // set tb_read to connect RAM to test bench
        tb_read = 1;

        // use tb_addr to read the data ram at that address
        tb_addr = 32'd16;
        // set the expected value at the address
        exp_val = 32'hBBBBFFFF;
        #1;
        // no endian conversion required in this case because we are dealing with byte addresses
        $display("mem[%h] = %h", tb_addr, data_readdata);
        #1;
        assert(exp_val == reverse_endian(data_readdata)) else $fatal(1, "expected = %h", exp_val);

        tb_addr = 32'd20;
        exp_val = 32'b11110000100101100011111011111000;
        $display("mem[%h] = %h", tb_addr, data_readdata);
        #1;
        assert(exp_val == reverse_endian(data_readdata)) else $fatal(1, "expected = %h, got=%h", exp_val, reverse_endian(data_readdata));

        $finish(0);
    end

    assign read = data_read | tb_read;
    always_comb begin
        if (tb_read) begin
            addr = tb_addr;
        end
        else begin
            addr = data_address;
        end
    end

    lwl_1_dram dram(
        .clk(clk),
        .data_address(addr),
        .data_write(data_write),
        .data_read(read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

    lwl_1_iram iram(
        .instr_address(instr_address),
        .instr_readdata(instr_readdata)
    );

    mips_cpu_harvard dut(
        .clk(clk),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .clk_enable(clk_enable),
        .instr_address(instr_address),
        .instr_readdata(instr_readdata),
        .data_address(data_address),
        .data_write(data_write),
        .data_read(data_read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    ); 

endmodule

// Data Memory before:

// 32d 8: 0xF1
// 32d 9: 0xF2
// 32d 10: 0xF3
// 32d 11: 0xF4

// Instruction Memory:

// LOAD BYTE

// addiu r10, r0,1000 // r10  = 1000
// addiu r11, r0,10 // r11 = 10


// lb r2, 8(r0) // r2 = MEM[8], should load byte 0 of word starting at address 8 into r2

// lb r3, -1(r11) // r2 = MEM[9], should load byte 1 of the word starting at address 8 into r3

// lb r4, 0(r11) // r2 = MEM[10], should load byte 2 of the word starting at address 8 into r4

// lb r5, 1(r11) // r2 = MEM[11], should load byte 3 of the word starting at address 8 into r5

// sw r2, -988(r10) // MEM[12] = r2 , should store the word (byte sign extended). The address tests negative offset addressing

// sw r3, -984(r10) // MEM[16] = r3 , should store the word (byte sign extended). The address tests negative offset addressing

// sw r4, 10(r11) // MEM[20] = r4 , should store the word (byte sign extended). Tests regular offset addressing
 
// sw r5, 14(r11) // MEM[24] = r5 , should store the word (byte sign extended). Tests regular offset addressing

// DATA MEMORY AFTER:

// 32d' 12: 0xF1FFFFFF
// 32d' 16: 0xF2FFFFFF
// 32d' 20: 0xF3FFFFFF
// 32d' 24: 0xF4FFFFFF