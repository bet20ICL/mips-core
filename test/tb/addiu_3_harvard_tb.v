module addiu_tb ();

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

    logic read, force_read;
    logic [31:0] addr, res_addr;
    logic [31:0] test;

    initial begin
        clk = 0;
        #4;
        repeat (10000) begin
            clk = ~clk;
            #4;
        end
        $fatal(2, "too long");
    end

    // initial begin
    //     force_read = 1;
    //     res_addr = 0;
    //     repeat (30) begin
    //         #1;
    //         $display("d_ram[%h] = %h", res_addr, data_readdata);
    //         res_addr += 1;
    //     end
    //     $finish(0);
    // end

    initial begin
        force_read=0;
        clk_enable = 1;
        reset = 1;
        @(posedge clk);
        #2;

        reset = 0;
        @(posedge clk);
        #2;

        while(active) begin
            @(posedge clk);
            #2;
        end

        i = 2;
        res_addr = 32'h00000480;
        force_read = 1;
        repeat(30) begin
            #1;
            exp_val = (16'h1111)*(i-2) + 32'h12345678 + (i-2) * 32'hdcba1234;
            assert(data_readdata==exp_val) else $fatal(1, "wrong value loaded: expected=%h, got=%h", exp_val, data_readdata);
            i = i+1;
            res_addr = res_addr + 4;
        end
        $finish(0);
    end

    assign read = data_read | force_read;
    assign addr = force_read ? res_addr : data_address;

    addiu_3_dram dram(
        .clk(clk),
        .data_address(addr),
        .data_write(data_write),
        .data_read(read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

    addiu_3_iram iram(
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