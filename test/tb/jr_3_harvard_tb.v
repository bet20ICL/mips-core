module jr_tb ();

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
    logic [31:0] addr, res_addr, data_out;
    logic [31:0] test;

    initial begin
        clk = 0;
        #4;
        repeat (100) begin
            clk = ~clk;
            #4;
        end
        $fatal(2, "too long");
    end

    logic [31:0] test_addr;

    initial begin
        force_read=0;
        clk_enable = 1;
        reset = 1;
        clk_enable = 1;
        @(posedge clk);
        @(posedge clk);
        #2;

        reset = 0;
        @(posedge clk);
        @(posedge clk);
        #2;

        while(active) begin
            @(posedge clk);
            #2;        
        end
        test = 0;
        force_read = 1;
        #2;
        res_addr = 32'h00000000;

        $finish(0);
    end

    assign read = data_read | force_read;
    always @(*) begin
        if (force_read) begin
            addr = res_addr;
        end
        else begin
            addr = data_address;
        end
    end

    jr_3_dram dram(
        .clk(clk),
        .data_address(addr),
        .data_write(data_write),
        .data_read(read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

    jr_3_iram iram(
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