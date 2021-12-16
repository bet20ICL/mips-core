module store_block(
    input logic [5:0] opcode,
    input logic [31:0] regword,
    input logic [31:0] dataword,
    input logic [31:0] eff_addr,
    output logic [31:0] storedata
);

    logic[2:0] bytenum;
    assign bytenum = eff_addr[1:0];
    logic[7:0] regbyte;
    assign regbyte = regword[7:0];
    logic[15:0] reghalfword;
    assign reghalfword = regword[15:0];

    always @(*) begin
        if (opcode == 6'b101011) begin   // sw
            // switch to big endian to store back into RAM
            storedata[7:0] = regword[31:24];
            storedata[15:8] = regword[23:16];
            storedata[23:16] = regword[15:8];
            storedata[31:24] = regword[7:0];
        end 
        else if (opcode == 6'b101000) begin  // sb
            // big endian
            case (bytenum)
                0: storedata = {regbyte, dataword[23:0]};
                1: storedata = {dataword[31:24], regbyte, dataword[25:0]};
                2: storedata = {dataword[31:16], regbyte, dataword[7:0]};
                3: storedata = {dataword[31:8], regbyte};
            endcase
        end 
        else if (opcode == 6'b101001) begin  // sh
            case (bytenum)
                0: storedata = {reghalfword, dataword[15:0]};
                2: storedata = {dataword[31:16], reghalfword};
            endcase
        end
    end

endmodule