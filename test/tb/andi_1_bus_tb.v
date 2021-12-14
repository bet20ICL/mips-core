module addu_tb();

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
        logic [31:0] expected;
        logic [31:0] test;
        logic [15:0] test_imm;
        logic [31:0] next_test;
        logic [31:0] ex_imm;
  
        reset = 1;
        clk_enable = 1;

        // ex_imm = $signed(16'h8888);
        // $display("%b", ex_imm);

        // i = 9;
        // ex_imm = $signed(16'h1111 * (i - 1));
        // $display("%b", ex_imm);

        @(posedge clk);
        #2;
        reset = 0;

        @(posedge clk);
        #2;

        i = 2;
        data_readdata = 32'h12345678;
        repeat (15) begin
            //lw ri, offset 
            //ri = 
            opcode = 6'b100011;
            rs = 5'b0;
            rt = i;
            imm = 16'b0;
            readdata = {opcode, rs, rt, imm};
            logic[6:0] c;
            c = 0;
            while (address==0) begin
                #1;
                assert(c!=31) else $fatal(1, "not loading");
                c = c+1;
            end


            readdata = data_readdata + 32'hdcba1234 * (i - 2);
            // $display("%h", data_readdata);
            @(posedge clk);
            #2;
            assert(!data_write) else $fatal(1, "data_write should not be active but is");
            assert(data_read) else $fatal(1, "data_read isn't active but should be");
            i = i + 1;
            data_readdata = readdata;
        end

        i = 2;
        repeat (15) begin
            //andi r2, r(i-1), r(i)
            opcode = 6'b001100;
            rs = i;
            rt = i + 15;
            imm = 16'h1111 * (i - 1);
            imm_instr = {opcode, rs, rt, imm};

            readdata = imm_instr;
            // expected = (32'h11111111 * (i - 1)) & (32'h11111111 * i);
            // $display("%h", expected);

            @(posedge clk);
            #2;
            i = i + 1;
        end 

        i = 2;
        test = 32'h12345678;
        repeat (15) begin
            //addiu r2, ri, 0
            //v0 -> ri
            opcode = 6'd9;
            rs = i + 15;
            rt = 5'd2;
            imm = 0;
            imm_instr = {opcode, rs, rt, imm};
            readdata = imm_instr; 

            @(posedge clk);
            #2;
            test_imm = 16'h1111 * (i - 1);
            ex_imm = {16'h0, test_imm};
            $display("%b", ex_imm);
            test = test + 32'hdcba1234 * (i - 2);
            expected = test & ex_imm;
            // $display("%h, %h", test, (test + 32'hdcba1234 * (i - 2))); 
            assert(register_v0 == expected) else $fatal(1, "expected=%h, v0=%h", expected, register_v0);
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