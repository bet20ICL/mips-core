module or_2_tb ();

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
    logic [31:0] test;

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
        tb_read=0;
        clk_enable = 1;
        reset = 1;
        @(posedge clk);
        #2;

        reset = 0;
        @(posedge clk);
        #2;

        while (active) begin
            @(posedge clk);
            #2;
        end
        
        tb_read = 1;
        tb_addr = 32'h100;
        i = 3;
        repeat (14) begin
            exp_val = 32'h12345678 + (i - 3) * 32'hdcba1234;
            #1;
            $display("mem[%h] = %h", tb_addr, reverse_endian(data_readdata));
            #1;
            assert(exp_val == reverse_endian(data_readdata)) else $fatal(1, "expected = %h", exp_val);
            tb_addr += 4;
            #1;
            i += 1;
        end
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

    lw_1_dram dram(
        .clk(clk),
        .data_address(addr),
        .data_write(data_write),
        .data_read(read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

    lw_1_iram iram(
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