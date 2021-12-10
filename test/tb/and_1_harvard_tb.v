module and_tb();

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
        logic[4:0] i;
        logic [31:0] expected;
  
        reset = 1;
        clk_enable = 1;

        @(posedge clk);
        #2;
        reset = 0;

        @(posedge clk);
        #2;

        i = 2;
        repeat (15) begin
            //lw r3, offset r2
            //r3 -> 9 
            opcode = 6'b100011;
            rs = 5'b0;
            rt = i;
            imm = 16'b0;
            imm_instr = {opcode, rs, rt, imm};

            instr_readdata = imm_instr;
            data_readdata = 32'h11111111 * (i - 1);
            $display("%h", data_readdata);

            @(posedge clk);
            #2;
            assert(!data_write) else $fatal(1, "data_write should not be active but is");
            assert(data_read) else $fatal(1, "data_read isn't active but should be");
            i = i + 1;
        end

        //and r2, r(i-1), r(i)
        opcode = 6'b0;
        funct = 6'b100100;
        rs = 3;
        rt = 4;
        rd = 2;
        r_instr = {opcode, rs, rt, rd, funct};
        instr_readdata = r_instr;

        @(posedge clk);
        #2;
        expected = (32'h11111111 * 2) & (32'h11111111 * 3); 
        assert(register_v0 == expected) else $fatal(1, "expected=%h, v0=%h", expected, register_v0);

        // i = 2;
        // repeat (15) begin
        //     //and r2, r(i-1), r(i)
        //     opcode = 6'b0;
        //     funct = 6'b100100;
        //     rs = i - 1;
        //     rt = i;
        //     rd = i + 15;
        //     r_instr = {opcode, rs, rt, rd, funct};
        //     instr_readdata = r_instr;

        //     @(posedge clk);
        //     #2;
        //     // expected = 32'h11111111 * (i - 1) & 32'h11111111 * i; 
        //     // assert() else $fatal(1, "");
        //     i = i + 1;
        // end

        // i = 17;
        // repeat (15) begin
        //     //addiu r2, ri, 0
        //     //v0 -> ri
        //     opcode = 6'd9;
        //     rs = i;
        //     rt = 5'd2;
        //     imm = 0;
        //     imm_instr = {opcode, rs, rt, imm};
        //     instr_readdata = imm_instr; 

        //     @(posedge clk);
        //     #2;
        //     $display("%h", register_v0);
        //     i = i + 1;
        // end

        // repeat (15) begin
        //     //and r2, r(i-1), r(i)
        //     opcode = 6'b0;
        //     funct = 6'b100100;
        //     rs = i - 1;
        //     rt = i;
        //     rd = 2;
        //     r_instr = {opcode, rs, rt, rd, funct};
        //     instr_readdata = r_instr;

        //     @(posedge clk);
        //     #2;
        //     $display("%h", register_v0);
        //     // expected = 32'h11111111 * (i - 1) & 32'h11111111 * i; 
        //     // assert() else $fatal(1, "");
        //     i = i + 1;
        // end

        // for (i = 15; i <= 31; i++){
        //     //and ri, r(i-16) r(i-15)
        //     //ri -> 11111 x 22222
        //     opcode = 6'b100011;
        //     rs = 6'd2;
        //     rt = 6'd3;
        //     imm = 0;
        //     imm_instr = {opcode, rs, rt, imm};

        //     instr_readdata = imm_instr;
        //     data_readdata = 32'h11111111 * (i - 1);
        //     #2;

        //     @(posedge clk);
        //     #2;
        //     assert(!data_write) else $fatal(1, "data_write should not be active but is");
        //     assert(data_read) else $fatal(1, "data_read isn't active but should be");
        //     assert(data_address == 0) else $fatal(1, "expected data_addr=%h, got %h", 2, data_address);
        // }

        
          
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