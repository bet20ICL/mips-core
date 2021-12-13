module memory_data_reg(

    input logic[31:0] readdata,
    input logic mdr_write,
    output logic[31:0] reg_write_data_b4mux

);
    
    always_comb begin
        if(mdr_write) begin
            reg_write_data_b4mux = readdata;
        end
    end


endmodule