module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);
    /*
        - still have to implement jump compatability (26 bits from j instruction need to get to alu mux somehow)
        - implement ALU and ALU control (which is within ALU in harvard??) into bus
        - finish control signals
        - implement waitrequest
        - implement
    */


    //state machine
    logic[2:0] state;

    state_machine sm(
        .clk(clk),
        .reset(reset),
        .state(state)
    );

    // Control Signals
    logic pc_write;
    logic pc_or_aluout;
    logic mem_read;
    logic mem_write;
    logic ir_write;
    logic a_write;
    logic b_write;
    logic mem_to_reg;
    logic reg_dst;
    logic mdr_write;
    logic reg_write;
    logic alu_out_write;
    logic alu_srca;
    logic[1:0] alu_srcb;
    logic[1:0] alu_op;
    logic pc_source;

    logic store;
    logic load;
    logic r_format;
    logic alui_instr;
    logic l_type;
    logic link_reg; //jalr
    // multiplication control
    logic muldiv;   //high if hi/lo need to be changed
    logic link_const; // jump or branch with link to r31
    logic link_const; // jump or branch with link to r31

    assign store = ((instr_opcode==6'b101000) || (instr_opcode==6'b101001) || (instr_opcode==6'b101011));
    assign load = ((instr_opcode==6'b100011) || (instr_opcode==6'b100101) || (instr_opcode==6'b100000) || (instr_opcode==6'b100100) || (instr_opcode==6'b100001) || (instr_opcode==6'b100010) || (instr_opcode==6'b100110));
    assign r_fromat = (instr_opcode==0);
    assign muldiv = r_format && (funct_code[4:3] == 2'b11 || funct_code == 6'b010001 || funct_code == 6'b010011);
    assign alui_instr = instr_opcode[5:3] == 3'b001;
    assign l_type = instr_opcode[5:3] == 3'b100;
    assign link_reg = (instr_opcode == 0 && readdata[5:0] == 6'b001001);
    assign link_const = (instr_opcode == 3) || (instr_opcode == 1 && readdata[20] == 1);

    //active for load instructions
    assign mem_read = load;
    //active for store instructions and in state 3
    assign mem_write = store && (state==3);
    assign ir_write = (state==0);
    assign mdr_write = (state==3);
    // active if instruction is R-type
    assign reg_dst = r_format;
    //writing to register either from memory or from ALU, depending on instruction type
    assign mem_to_reg = load;
    assign reg_write = ((r_format && !muldiv) || alui_instr || l_type || link_reg || link_const);
    // not too sure, gotta figure out alu_srca and alu_srcb
    assign alu_srca = (state!=0 && )
    assign alu_out_write = (state==2) || (state==1 && !alu_srca);
    assign pc_write

    //Regfile I/O & IR outputs
    logic[4:0] reg_a_read_index;
    logic[4:0] reg_b_read_index;
    logic[4:0] reg_write_index;
    logic[31:0] reg_write_data;
    logic[31:0] read_data1;
    logic[31:0] read_data2;
    logic[31:0] register_v0;
    logic[4:0] reg_write_index_beforemux;
    logic[15:0] offset_b4extend;

    //control block input
    logic[5:0] instr_opcode;

    //IR register
    instruction_register IR(
        .readdata(readdata),
        .ir_write(ir_write),
        .instr_opcode(instr_opcode),
        .reg_a_read_index(reg_a_read_index),
        .reg_b_read_index(reg_b_read_index),
        .reg_write_index_beforemux(reg_write_index_beforemux),
        .offset_b4extend(offset_b4extend)
    );

    logic[5:0] funct_code;
    assign funct_code = offset_b4extend[5:0];

    //MDR register
    memory_data_reg MDR(
        .readdata(readdata),
        .mdr_write(mdr_write),
        .reg_write_data_b4mux(reg_write_data_b4mux)
    );

    assign reg_write_index = reg_dst ? reg_write_index_beforemux : reg_b_read_index;
    assign reg_write_data = mem_to_reg ? reg_write_data_b4mux : alu_out;

    regfile registerfiles(
        .r_clk(clk),
        .reset(reset),
        .r_clk_enable(clk_enable),
        .read_reg1(reg_a_read_index),
        .read_reg2(reg_b_read_index),
        .write_control(reg_write),
        .write_reg(reg_write_index),
        .write_data(reg_write_data),
        .read_data1(reg_a_read_data),
        .read_data2(reg_b_read_data),
        .register_v0(register_v0)
    );

    //reg a & b outputs
    logic[31:0] aout;
    logic[31:0] bout;

    reg_a rega(
        .a_write(a_write),
        .regout(read_data1),
        .aout(aout)
    );
    reg_b regb(
        .b_write(b_write),
        .regout(read_data2),
        .bout(bout)
    );

    //pc stuff
    logic[31:0] next_instr_addr;
    logic[31:0] curr_addr;

    assign next_instr_addr = pc_source ? alu_out : alu_out_b4reg;

    // need to implement muxes and adder like in harvard for PC: PC+4 still i think
    pc_bus pc(
        .clk(clk),
        .next_addr(next_instr_addr),
        .reset(reset),
        .pc_write(pc_write),
        .curr_addr(curr_addr)
    );

    logic[31:0] offset;
    logic[31:0] offset_shifted;
    assign offset {16'h0, offset_b4extend};
    assign offset_shifted = offset << 2;

    //ALU stuff
    logic[31:0] alu_op1;
    logic[31:0] alu_op2;
    logic[3:0] alu_control_out;
    logic[31:0] alu_out;
    logic[31:0] alu_out_b4reg;

    assign alu_op1 = alu_srca ? aout : curr_addr;
    assign alu_op2 = (alu_srcb=0) ? bout : (alu_srcb=1 ? 4 : (alu_srcb=2 ? offset : offset_shifted))
    
    alu alu(
        .control(alu_control_out),
        .op1(alu_op1),
        .op2(alu_op2),
        .result(alu_out_b4reg),
        // some missing ?? in harvard too
    );
    alu_out_reg aluoutreg(
        .alu_out_write(alu_out_write),
        .alu_out_b4reg(alu_out_b4reg),
        .alu_out(alu_out)
    );

    assign writedata = bout;
    assign address = pc_or_aluout ? alu_out : curr_addr;

endmodule