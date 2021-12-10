CPU I/O:

clk,
reset,
active,
register_v0,

clk_enable,

instr_address,
instr_readdata,


data_address,
data_write,
data_read,
data_writedata,
data_readdata

control signals:
reg_dst     x
mem_read    x
mem_to_reg  x
mem_write   x
reg_write   - 
muldiv      x
mfhi        -
mflo        -
j_imm       
j_reg
j_type

PC:
clk,
next_addr,
reset,
active,
curr_addr

HI/LO Registers:
Inputs      x
Outputs     x

Register File:
r_clk       x
reset       x
r_clk_enable    x
write_control   x
read_reg1   x
read_reg2   x
write_reg   x
write_data  x
read_data1  x
read_data2  x
register_v0 x

