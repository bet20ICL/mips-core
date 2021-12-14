//Combinatorial read, single cycle write

module data_ram (
    input logic clk,
    input logic[31:0]   data_address,
    input logic         data_write,
    input logic         data_read,
    input logic[31:0]   data_writedata,
    input logic         word_adress, 
    output logic[31:0]  data_readdata
);



    reg [7:0] ram [65535:0];
    integer i;
    
    initial begin
        for(i=0;i<65535;i=i+1)
            ram[i] <= 8'd0;
    end
    always @(posedge clk) begin

        if (data_write) bgein

            if(word_adress) begin
                ram[data_adress] <= data_writedata[7:0];
                ram[data_adress] <= data_writedata[15:8];
                ram[data_adress] <= data_writedata[23:16];
                ram[data_adress] <= data_writedata[31:23];
            end 
            else begin

                if (data_adress % 4 ==0) 
                    ram[data_adress] <= data_writedata[7:0]
                if ((data_adress-1) % 4 ==0) 
                    ram[data_adress] <= data_writedata[15:8]
                if ((data_adress-2) % 4 ==0) 
                    ram[data_adress] <= data_writedata[23:16]
                if ((data_adress-3) % 4 ==0)
                    ram[data_adress] <= data_writedata[31:23]
            end

        end 
    end
    if (word_adress) begin

        assign data_readdata[7:0] = ram[data_address];
        assign data_readdata[15:8] = ram[data_address+1];
        assign data_readdata[23:16] = ram[data_address+2];
        assign data_readdata[31:24] = ram[data_address+3];
    end 

    else begin

        if (data_adress % 4 == 0)
            assign data_readdata[7:0] = ram[data_adress];
        else if ((data_adress-1) % 4 == 0)
            assign data_readdata[15:8] = ram[data_address];
        else if ((data_adress-2) % 4 == 0)
            assign data_readdata[23:16] = ram[data_address];
        else 
            assign data_readdata[31:24] = ram[data_address];
    end
endmodule
    

