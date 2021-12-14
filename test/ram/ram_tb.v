module ram_tb();

    logic clk;
    logic[31:0]   addr;
    logic         write;
    logic         read;
    logic[31:0]   data_write;
    logic         word; 
    logic[31:0]  data;
    logic wait_request;



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
    word = 1;
    
    
    @(posedge clk);
    #1;

    write = 0;
    read = 1;
    #2;
    $display("%b, data_write = %b", data, data_write);
    assert(data == data_write) else $fatal(1, "wrong value");
    assert(wait_request==0) else $fatal(1, "wait request high");
    $display("succ");
    $finish(0);
end

ram dut(
    .clk(clk),
    .data_write(write),
    .data_read(read),
    .data_address(addr),
    .data_writedata(data_write),
    .data_readdata(data),
    .word_address(word),
    .wait_request(wait_request)
);

endmodule