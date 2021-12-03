module addiu_tb();

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
        #4;
        repeat (1000) begin
            clk = ~clk;
            #4;
        end
    end

    initial begin
        
        clk_enable = 1;
        reset = 0;

        #1;
        /* $12 = 4 */
        instr_readdata = 32'b10001100000011000000000000000000;
        data_readdata = 32'd4;
        #2;
        /* addiu: $3 = $12 + 100 */
        instr_readdata = 32'b00100101100000110000000001101000;
        #2;
        /*important to get time delay correct, so it checks everything done in correct amount of clock cycles */
        instr_readdata = 32'b10101100000000110000000000000000;
        #2;
    

        assert(data_writedata==32'd104) else $fatal(1, "expected output=104, got output=%d",data_writedata);

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