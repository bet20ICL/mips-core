module ram_havard_tb();

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

    initial begin
        clk = 0;
        #4;
        repeat (1000) begin
            clk = ~clk;
            #4;
        end
    end




    // mips_cpu_harvard dut(
    //     .clk(clk),
    //     .reset(reset),
    //     .active(active),
    //     .register_v0(register_v0),
    //     .clk_enable(clk_enable),
    //     .instr_address(instr_address),
    //     .instr_readdata(instr_readdata),
    //     .data_address(data_address),
    //     .data_write(data_write),
    //     .data_read(data_read),
    //     .data_writedata(data_writedata),
    //     .data_readdata(data_readdata)
    // );

endmodule