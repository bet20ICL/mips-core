module lw_tb();

    logic     clk;
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

    /* memory initialisation */
    logic init_mem, instr_active;
    logic[31:0] init_mem_addr;
    logic[31:0] init_instr;

    initial begin
        clk = 0;
        #1;
        repeat (1000) begin
            clk = ~clk;
            #1;
        end
    end

    initial begin
        
        #1;
        /* $8=mem[$0+100] */
        instr_readdata = 32'b10000000110010000000000001101000;
        data_readdata = 32'd9;
        #2;

        assert(!data_write) else $fatal(1, "data_write should not be active but is");
        assert(data_read) else $fatal(1, "data_read isn't active but should be");
        assert(data_address==100) else $fatal(1, "address from memory being loaded, incorrect");
        #2;
        /* checks register 8*/
        instr_readdata = 32'b10101100000010000000000000000000;

        assert(data_writedata==9) else $fatal(1, "incorrect value loaded to register");
       
    end


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