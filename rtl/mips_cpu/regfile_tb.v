module regfile_tb();

    logic clk;
    logic reset;
    logic r_clk_enable;
    /* control line for writing data*/
    logic write_control;
    /* registers being read */
    logic[4:0] read_reg1;
    logic[4:0] read_reg2;
    /* register data written to; then actual data written*/
    logic[4:0] write_reg;
    logic[31:0] write_data;
    /* data read from registers*/
    logic[31:0] read_data1;
    logic[31:0] read_data2;

    initial begin
        clk = 0;
        repeat(1000) begin
            clk = ~clk;
            #1;
        end
    end

    initial begin
        r_clk_enable = 1;
        read_reg1 = 0;

        #1;
        write_control = 1;
        write_reg = 2;
        write_data = 5;
        #2;
        read_reg1 = 2;
        $display(read_data1);
    end

    regfile dut(
        .r_clk(clk),
        .reset(reset),
        .r_clk_enable(r_clk_enable),
        .write_control(write_control),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

endmodule