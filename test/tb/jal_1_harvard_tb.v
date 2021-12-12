module jal_tb();

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
        logic [31:0] test;
        logic [15:0] test_imm;
        logic [31:0] next_test;
        logic [25:0] j_addr;
        logic [31:0] curr_addr;
        logic [31:0] tmp;
        logic [31:0] link_addr;
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
        curr_addr = 32'hBFC00000;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);
        
        @(posedge clk);
        #2;
        curr_addr = curr_addr + 4;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);

        //jal
        opcode = 6'b000011;
        j_addr = 26'h2;
        instr_readdata = {opcode, j_addr};
        tmp = curr_addr + 4;
        link_addr = curr_addr + 8;
        curr_addr = {tmp[31:28], j_addr, 2'b0};

        // $display("%h", data_readdata);
        @(posedge clk);
        #2;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);

        //addiu r2 r31 0  
        //ri = 
        opcode = 6'd9;
        rs = 5'd31;
        rt = 5'd2;
        imm = 0;
        imm_instr = {opcode, rs, rt, imm};
        instr_readdata = imm_instr; 

        curr_addr += 4;
        @(posedge clk);
        #2;
        assert(instr_address == curr_addr) else $fatal(1, "expected pc=%h, actual pc=%h", curr_addr, instr_address);
        assert(register_v0 == link_addr) else $fatal(1, "expected v0=%h, actual=%h", link_addr, register_v0);


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