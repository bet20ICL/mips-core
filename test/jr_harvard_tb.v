/* 
    JR: jumps to address in specified register
    data_address will output the pc
    we want to read data_address and make sure the output is what is in the reg
    v0 is the register output
    we compare data_address and v0_register
*/

module JR_tb();

    logic     clk;
    logic     reset;
    logic    active;
    logic[31:0] register_v0;

    /* New clock enable. See below. */
    logic     clk_enable;

    /* Combinatorial read access to instructions */
    logic[31:0]  instr_address;
    logic[31:0]   instr_readdata;

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
        reset = 0;
        #1;
        reset = 1;
        #1;
        reset = 0;
        #1;

        init_mem = 1;
        init_mem_addr = 32'h 0;

        $display("succ");
    end


    data_ram instr(
        .clk(clk),
        .data_address(init_mem_addr),
        .data_write(init_mem),
        .data_read(instr_active),
        .data_writedata(init_instr),
        .data_readdata(data_readdata)
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