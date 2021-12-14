module bne_tb();

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
        //r type
        logic [4:0] rd; 
        logic [5:0] funct;
        logic [31:0] r_instr;
        logic [4:0] shamt;
        logic[4:0] i;
        logic [31:0] test;
        logic [15:0] test_imm;
        logic [31:0] next_test;
        logic [25:0] j_addr;
        logic [31:0] curr_addr;
        logic [31:0] tmp;
        logic [31:0] link_addr;
        logic[17:0] b_imm;
        logic[31:0] b_offset;
        reset = 1;
        clk_enable = 1;
        

        // ex_imm = $signed(16'h8888);
        // $display("%b", ex_imm);

        // i = 9;
        // ex_imm = $signed(16'h1111 * (i - 1));
        // $display("%b", ex_imm);

        @(posedge clk);
        #2;

        @(posedge clk);
        #2;
        reset = 0;
        // dummy lw instruction
        opcode = 6'b100011;
        rs = 5'd1;
        rt = 5'd3;
        imm = 16'b0;
        imm_instr = {opcode, rs, rt, imm};
        readdata = imm_instr;
        while (read==0) begin
            #1;
            assert(i!=31) else $fatal(1, "not loading");
            i = i+1;
        end        
        
        // check reset address is correct
        curr_addr = 32'hBFC00000;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);

        @(posedge clk);
        #2;
        curr_addr = curr_addr + 4;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);

        // start testing
        // initialise r2 - r31 all with 32'h12345678 using lw
        i = 2;
        data_readdata = 32'h12345678;
        repeat (30) begin
            //lw ri
            opcode = 6'b100011;
            rs = 5'b0;
            rt = i;
            imm = 16'b0;
            imm_instr = {opcode, rs, rt, imm};
            readdata = imm_instr;
            while (read==0) begin
                #1;
                assert(i!=31) else $fatal(1, "not loading");
                i = i+1;
            end
            readdata = data_readdata;

            @(posedge clk);
            #2;
            assert(!write) else $fatal(1, "data_write should not be active but is");
            assert(read) else $fatal(1, "data_read isn't active but should be");
            curr_addr = curr_addr + 4;
            assert(address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, address);
            i = i + 1;
        end

        // beq r3, r2; beq r4, r3; beq r5, r4, etc.
        // immediate = h3333, h4444 etc.
        // all comparisons should branch
        i = 3;
        repeat (29) begin
            opcode = 6'b101;
            rs = i - 1;
            rt = i;
            imm = 16'b1111 * i; 
            imm_instr = {opcode, rs, rt, imm};
            readdata = imm_instr;

            @(posedge clk);
            #2;
            curr_addr = curr_addr + 4;
            assert(address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, address);

            i = i + 1;
        end

        // initialise r2 - r31 all with 32'h12345678 + n 32'hdcba1234
        // to form an arithmetic series
        i = 2;
        data_readdata = 32'h12345678;
        repeat (30) begin
            //lw ri
            opcode = 6'b100011;
            rs = 5'b0;
            rt = i;
            imm = 16'b0;
            imm_instr = {opcode, rs, rt, imm};
            readdata = imm_instr;
            while (read==0) begin
                #1;
                assert(i!=31) else $fatal(1, "not loading");
                i = i+1;
            end
            readdata = data_readdata;

            @(posedge clk);
            #2;
            assert(!data_write) else $fatal(1, "data_write should not be active but is");
            assert(data_read) else $fatal(1, "data_read isn't active but should be");
            curr_addr = curr_addr + 4;
            assert(address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, address);
            i = i + 1;
            data_readdata = readdata + 32'hdcba1234;
        end

        // beq r3, r2; beq r4, r3; beq r5, r4, etc.
        // immediate = h3333, h4444 etc.
        // no comparisons should branch
        i = 3;
        repeat (29) begin
            opcode = 6'b101;
            rs = i - 1;
            rt = i;
            imm = 16'b1111 * i; 
            imm_instr = {opcode, rs, rt, imm};
            readdata = imm_instr;

            @(posedge clk);
            #2;
            b_imm = imm << 2;
            b_offset = {b_imm[17] ? 14'h3FFF : 14'h0, b_imm};
            curr_addr = curr_addr + 4 + b_offset;
            assert(address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, address);
            i = i + 1;
        end
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