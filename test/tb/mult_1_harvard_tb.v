module mult_tb();

    logic     clk;
    logic     reset;
    logic    active;
    logic[31:0] register_v0;

    /* New clock enable. See below. */
    logic     clk_enable;

    /* Combinatorial read access to instructions */
    logic[31:0]  instr_address;
    logic[31:0]  instr_readdata;

    /* Combinatorial read and single-cycle write access to instructions */
    logic[31:0]  data_address, data_address_wanted;
    logic        data_write;
    logic        data_read;
    logic[31:0]  data_writedata;
    logic[31:0]  data_readdata;

    /* memory initialisation */
    logic init_mem, instr_active;
    logic[31:0] init_mem_addr;
    logic[31:0] init_instr;

    initial begin
        clk = 0;
        #4;
        repeat (100) begin
            clk = ~clk;
            #4;
        end
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
        logic [63:0] expected;
        logic [31:0] test;
        logic [31:0] next_test;
  
        reset = 1;
        clk_enable = 1;

        @(posedge clk);
        #2;
        reset = 0;

        @(posedge clk);
        #2;

        i = 3;
        data_readdata = 32'h12345678;
        repeat (29) begin
            //lw ri, offset 
            //ri = 
            opcode = 6'b100011;
            rs = 5'b0;
            rt = i;
            imm = 16'b0;
            imm_instr = {opcode, rs, rt, imm};

            instr_readdata = imm_instr;
            // $display("%h", data_readdata);
            @(posedge clk);
            #2;
            assert(!data_write) else $fatal(1, "data_write should not be active but is");
            assert(data_read) else $fatal(1, "data_read isn't active but should be");
            data_readdata = data_readdata + 32'hdcba1234;
            i = i + 1;
        end

        i = 3;
        test = 32'h12345678;
        repeat (28) begin
            //mult r(i), r(i + 1)
            opcode = 6'b0;
            funct = 6'b011000;
            shamt = 6'b0;
            rs = i;
            rt = i + 1;
            rd = 0;
            r_instr = {opcode, rs, rt, rd, shamt, funct};
            instr_readdata = r_instr;
            expected = $signed(test) * $signed(test + 32'hdcba1234);
            // expected = (32'h11111111 * (i - 1)) & (32'h11111111 * i);
            // $display("%h", expected);

            @(posedge clk);
            #2;
            // mflo 0
            opcode = 6'b0;
            funct = 6'b010010;
            shamt = 6'b0;
            rs = 0;
            rt = 0;
            rd = 2;
            r_instr = {opcode, rs, rt, rd, shamt, funct};
            instr_readdata = r_instr;
            
            @(posedge clk);
            #2;
            assert(register_v0 == expected[31:0]) else $fatal(1, "expected=%h, v0=%h", expected[31:0], register_v0);

            // mfhi 0
            opcode = 6'b0;
            funct = 6'b010000;
            shamt = 6'b0;
            rs = 0;
            rt = 0;
            rd = 2;
            r_instr = {opcode, rs, rt, rd, shamt, funct};
            instr_readdata = r_instr;

            @(posedge clk);
            #2;
            assert(register_v0 == expected[63:32]) else $fatal(1, "expected=%h, v0=%h", expected[63:32], register_v0);
            test = test + 32'hdcba1234;
            i = i + 1;
        end 

    end

    mips_cpu_harvard dut(
        .clk(clk),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .clk_enable(clk_enable),
        .instr_address(instr_address),
        .instr_readdata(instr_readdata),
        .data_address(data_address),
        .data_write(data_write),
        .data_read(data_read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

endmodule