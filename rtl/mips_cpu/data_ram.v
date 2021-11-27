//Combinatorial read, single cycle write

module data_ram (
    input logic clk,
    input logic[31:0]  data_address,
    input logic        data_write,
    input logic        data_read,
    input logic[31:0]  data_writedata,
    output logic[31:0]  data_readdata
);



    reg [31:0] ram [65535:0];
    integer i;
    
    initial begin
        for(i=0;i<65535;i=i+1)
            ram[i] <= 32'd0;
    end
    always @(posedge clk) begin
        if (data_write)
            ram[data_address] <= data_writedata;
    end
    assign data_readdata = ram[data_address];
endmodule

