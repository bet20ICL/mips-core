module regfile(
    input logic r_clk,
    input logic reset,
    input logic r_clk_enable,
    /* control line for writing data */
    input logic write_control,
    /* registers being read */
    input logic[4:0] read_reg1,
    input logic[4:0] read_reg2,
    /* register data written to, then actual data written*/
    input logic[4:0] write_reg,
    input logic[31:0] write_data,
    /* data read from registers*/
    output logic[31:0] read_data1,
    output logic[31:0] read_data2,
    output logic[31:0] register_v0
);

    reg[31:0] registers[31:0];

    initial begin
        registers[0]=0;
        registers[1]=0;
        registers[2]=0;
        registers[3]=0;
        registers[4]=0;
        registers[5]=0;
        registers[6]=0;
        registers[7]=0;
        registers[8]=0;
        registers[9]=0;
        registers[10]=0;
        registers[11]=0;
        registers[12]=0;
        registers[13]=0;
        registers[14]=0;
        registers[15]=0;
        registers[16]=0;
        registers[17]=0;
        registers[18]=0;
        registers[19]=0;
        registers[20]=0;
        registers[21]=0;
        registers[22]=0;
        registers[23]=0;
        registers[24]=0;
        registers[25]=0;
        registers[26]=0;
        registers[27]=0;
        registers[28]=0;
        registers[29]=0;
        registers[30]=0;
        registers[31]=0;
    end

    always_ff @(posedge r_clk) begin
        if (reset) begin
            registers[0]<=32'd0;
            registers[1]<=32'd0;
            registers[2]<=32'd0;
            registers[3]<=32'd0;
            registers[4]<=32'd0;
            registers[5]<=32'd0;
            registers[6]<=32'd0;
            registers[7]<=32'd0;
            registers[8]<=32'd0;
            registers[9]<=32'd0;
            registers[10]<=32'd0;
            registers[11]<=32'd0;
            registers[12]<=32'd0;
            registers[13]<=32'd0;
            registers[14]<=32'd0;
            registers[15]<=32'd0;
            registers[16]<=32'd0;
            registers[17]<=32'd0;
            registers[18]<=32'd0;
            registers[19]<=32'd0;
            registers[20]<=32'd0;
            registers[21]<=32'd0;
            registers[22]<=32'd0;
            registers[23]<=32'd0;
            registers[24]<=32'd0;
            registers[25]<=32'd0;
            registers[26]<=32'd0;
            registers[27]<=32'd0;
            registers[28]<=32'd0;
            registers[29]<=32'd0;
            registers[30]<=32'd0;
            registers[31]<=32'd0;
        end
        else if(r_clk_enable) begin
            if(write_control && write_reg!=0) begin
                registers[write_reg] <= write_data;
            end
        end
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
    assign register_v0 = registers[2];

endmodule