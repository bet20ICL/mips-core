module ram_tb();

logic clk;
logic write;
logic read;
logic[31:0] addr;
logic[31:0] data_write;
logic[31:0] data;


initial begin
    clk = 0;
    #1;
    repeat(1000) begin
        clk = ~clk;
        #1;
    end
end

initial begin
    write = 1;
    addr = 4;
    data_write = 32'hBF000000;
    
    @(posedge clk);
    #1;

    write = 0;
    read = 1;
    #2;
    $display(data);
    assert(data == data_write) else $fatal(1, "wrong value");
    $display("succ");
    $finish(0);
end

ram dut(
    .clk(clk),
    .write(write),
    .read(read),
    .addr(addr),
    .data_write(data_write),
    .data(data)
);

endmodule