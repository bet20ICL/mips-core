module sw_tb();

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
        
        reset=1;
        clk_enable=1;

        @(posedge clk);
        #1;
        reset=0;

        @(posedge clk);
        #1;
        /* $7=14 */
        instr_readdata = 32'b10001100000001110000000000000000;
        data_readdata = 32'd14;
        
        @(posedge clk);
        #1;
        /* $2=10 */
        instr_readdata = 32'b10001100000000100000000000000000;
        data_readdata = 32'd10;
        
        @(posedge clk);
        #1;
        /* mem[$2+100]=$7 */
        instr_readdata = 32'b10101100010001110000000001100100;

        @(posedge clk);
        #1;
        $display(register_v0);

        assert(data_write) else $fatal(1,"write signal not active, when it should be");
        assert(!data_read) else $fatal(1, "read signal active when it should'nt be");
        assert(data_address==110) else $fatal(1, "expected addres to be written to to be=110, got =%d",data_address);
        assert(data_writedata==14) else $fatal(1, "expected data being written to be=14, got =%d",data_writedata);
       
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