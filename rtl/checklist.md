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
reg_write   x
muldiv      x
mfhi        x
mflo        x
j_imm       x
j_reg       x

PC:
clk     x
next_addr   x
reset   x
active  x
curr_addr   x

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

ALU:
op1     x
op2     x
instructionword     x
result x
hi      x
lo      x
memaddroffset   x
b_flag  x

//

ADDIU	Add immediate unsigned (no overflow) r  t
ADDU	Add unsigned (no overflow) r    t
AND	Bitwise and r   t
ANDI	Bitwise and immediate r     t
BEQ	Branch on equal -
BGEZ	Branch on greater than or equal to zero -
BGEZAL	Branch on non-negative (>=0) and link r -
BGTZ	Branch on greater than zero -
BLEZ	Branch on less than or equal to zero -
BLTZ	Branch on less than zero -
BLTZAL	Branch on less than zero and link r -
BNE	Branch on not equal -
DIV	Divide -    t
DIVU	Divide unsigned -   t
J	Jump -
JALR	Jump and link register r -
JAL	Jump and link r -
JR	Jump register -
LB	Load byte r 
LBU	Load byte unsigned r
LH	Load half-word r
LHU	Load half-word unsigned r
LUI	Load upper immediate r
LW	Load word r
LWL	Load word left r
LWR	Load word right r
MTHI	Move to HI -    t
MTLO	Move to LO -    t
MULT	Multiply -  t
MULTU	Multiply unsigned - t
OR	Bitwise or r    t
ORI	Bitwise or immediate r  t
SB	Store byte x
SH	Store half-word x
SLL	Shift left logical  t
SLLV	Shift left logical variable t
SLT	Set on less than (signed)   t
SLTI	Set on less than immediate (signed) r   t
SLTIU	Set on less than immediate unsigned   t  
SLTU	Set on less than unsigned r t
SRA	Shift right arithmetic r    t
SRAV	Shift right arithmetic r    t
SRL	Shift right logical r   t
SRLV	Shift right logical variable r  t
SUBU	Subtract unsigned r x t
SW	Store word
XOR	Bitwise exclusive or r x    t
XORI	Bitwise exclusive or immediate r    t


// 
opcode = 0 and not mthi mtlo

op rs rt rd

Type	31:26	25:21	20:16	15:11	10:06	05:00
R-Type	opcode	$rs	    $rt	    $rd	    shamt	funct
I-Type	opcode	$rs	    $rt	    imm
J-Type	opcode	address
