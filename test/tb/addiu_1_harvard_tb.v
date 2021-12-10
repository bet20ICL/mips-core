module addiu_tb();

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
        repeat (1000) begin
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
        reset = 1;
        clk_enable = 1;

        @(posedge clk);
        #2;
        reset = 0;

        @(posedge clk);
        #2;

        //addiu r2, r3, 2
        //v0 -> 2
        opcode = 6'd9;
        rs = 6'd3;
        rt = 6'd2;
        imm = 16'd2;
        imm_instr = {opcode, rs, rt, imm};
        instr_readdata = imm_instr;     
        
        @(posedge clk);
        #2;
        assert(!data_write) else $fatal(1, "data_write should not be active but is");
        assert(!data_read) else $fatal(1, "data_read isn't active but should be");
        assert(register_v0 == 2) else $fatal(1, "expected v0=2, got output=%d", register_v0);

        // //lw r2, offset r3
        // //v0 -> 9 
        // opcode = 6'b100011;
        // rs = 6'd3;
        // rt = 6'd2;
        // imm = 0;
        // imm_instr = {opcode, rs, rt, imm};

        // instr_readdata = imm_instr;
        // data_readdata = 32'd9;
        // #2;

        // @(posedge clk);
        // #2;
        // assert(!data_write) else $fatal(1, "data_write should not be active but is");
        // assert(data_read) else $fatal(1, "data_read isn't active but should be");
        // assert(data_address == 0) else $fatal(1, "address from memory being loaded, incorrect");
        // assert(register_v0 == 9) else $fatal(1, "wrong value loaded");


        // //addiu r2, r3, 2
        // //v0 -> 9 
        // opcode = 6'd9;
        // rs = 6'd3;
        // rt = 6'd2;
        // imm = 16'd2;
        // imm_instr = {opcode, rs, rt, imm};
        // instr_readdata = imm_instr;     

        // @(posedge clk);
        // #2;
        // assert(!data_write) else $fatal(1, "data_write should not be active but is");
        // assert(!data_read) else $fatal(1, "data_read isn't active but should be");
        // assert(register_v0 == 2) else $fatal(1, "expected v0=2, got output=%d", register_v0);
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