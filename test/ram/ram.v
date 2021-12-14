//Combinatorial read, single cycle write

module ram (
    input logic clk,
    input logic[31:0]   data_address,
    input logic         data_write,
    input logic         data_read,
    input logic[31:0]   data_writedata,
    input logic         word_address, 
    output logic[31:0]  data_readdata,
    output logic wait_request
);

    // making sure that after reset the address will be going from 0


    reg [7:0] ram [0:65535];
    logic[31:0] new_addr;

    initial begin
        ram[0] = 0;
    end

    assign wait_request=0;

    assign new_addr = data_address % (32'hBFC00000);
    
    always @(posedge clk) begin

        if (data_write) begin

            if(word_address) begin
                ram[new_addr] <= data_writedata[7:0];
                ram[new_addr+1] <= data_writedata[15:8];
                ram[new_addr+2] <= data_writedata[23:16];
                ram[new_addr+3] <= data_writedata[31:24];
            end 
            else begin

                if (new_addr % 4 ==0) begin
                    ram[new_addr] <= data_writedata[7:0];
                end
                if ((new_addr+1) % 4 ==0) begin
                    ram[new_addr] <= data_writedata[15:8];
                end
                if ((new_addr+2) % 4 ==0) begin         
                    ram[new_addr] <= data_writedata[23:16];
                end 
                if ((new_addr+3) % 4 ==0) begin
                    ram[new_addr] <= data_writedata[31:24];
                end
            end

        end 
        if (word_address) begin
            data_readdata <= {ram[new_addr+3], ram[new_addr+2], ram[new_addr+1], ram[new_addr]};
        end 

        else begin
            data_readdata = 0;
            if (new_addr % 4 == 0)
                data_readdata[7:0] = ram[new_addr];
            else if ((new_addr-1) % 4 == 0)
                data_readdata[15:8] = ram[new_addr];
            else if ((new_addr-2) % 4 == 0)
                data_readdata[23:16] = ram[new_addr];
            else 
                data_readdata[31:24] = ram[new_addr];
        end
    end
endmodule
    

