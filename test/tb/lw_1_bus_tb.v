module lw_tb();

    logic     clk;
    logic     reset;
    logic    active;
    logic[31:0] register_v0;

    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    initial begin
        clk = 0;
        #4;
        repeat (1000) begin
            clk = ~clk;
            #4;
        end;
    end

    initial begin
        //instantiate variables for easier instruction building
        logic [5:0] opcode;
        logic [4:0] rt;
        logic [4:0] rs;
        logic [15:0] imm;
        logic [31:0] imm_instr;
        
        reset = 1;
        clk_enable = 1;

        @(posedge clk);
        #2;
        reset = 0;

        @(posedge clk);
        #2;

        //lw r2, offset r3
        //v0 -> 9 
        opcode = 6'b100011;
        rs = 6'd3;
        rt = 6'd2;
        imm = 0;
        imm_instr = {opcode, rs, rt, imm};

<<<<<<< HEAD
        instr_readdata = imm_instr;
        data_readdata = 32'd9;
=======
        readdata = imm_instr;
        while (address==0) begin
            #1;
        end
        readdata = 32'd9;
>>>>>>> bus_tb
        #2;

        @(posedge clk);
        #2;
<<<<<<< HEAD
        assert(!data_write) else $fatal(1, "data_write should not be active but is");
        assert(data_read) else $fatal(1, "data_read isn't active but should be");
        assert(data_address == 0) else $fatal(1, "address from memory being loaded, incorrect");
        assert(register_v0 == 9) else $fatal(1, "wrong value loaded");

        //lw r3, offset r8
        //r3 -> 1
        opcode = 6'b100011;
        rs = 6'd8;
        rt = 6'd3;
        imm = 32'h8;
        imm_instr = {opcode, rs, rt, imm};

        instr_readdata = imm_instr;
        data_readdata = 32'd16;

        @(posedge clk);
        #2;
        assert(!data_write) else $fatal(1, "data_write should not be active but is");
        assert(data_read) else $fatal(1, "data_read isn't active but should be");
        assert(data_address == {16'b0, imm} + 0) else $fatal(1, "address from memory being loaded, incorrect");
        assert(register_v0 == 9) else $fatal(1, "wrong value loaded");

        //lw r2, offset r3
        //r2 -> 1
        opcode = 6'b100011;
        rs = 6'd3;
        rt = 6'd2;
        imm = 32'h8;
        imm_instr = {opcode, rs, rt, imm};

        instr_readdata = imm_instr;
        data_readdata = 32'd10;

        @(posedge clk);
        #2;
        assert(!data_write) else $fatal(1, "data_write should not be active but is");
        assert(data_read) else $fatal(1, "data_read isn't active but should be");
        assert(data_address == {16'b0, imm} + 16) else $fatal(1, "address from memory being loaded, incorrect");
        assert(register_v0 == 10) else $fatal(1, "wrong value loaded");
=======
        assert(!write) else $fatal(1, "data_write should not be active but is");
        assert(read) else $fatal(1, "data_read isn't active but should be");
        assert(address == 0) else $fatal(1, "address from memory being loaded, incorrect");
        assert(register_v0 == 9) else $fatal(1, "wrong value loaded");

        $finish(0);

>>>>>>> bus_tb
    end

    mips_cpu_bus dut(
        .clk(clk),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );

endmodule