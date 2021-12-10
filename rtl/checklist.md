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

ADDIU	Add immediate unsigned (no overflow) r
ADDU	Add unsigned (no overflow) r
AND	Bitwise and r
ANDI	Bitwise and immediate r
BEQ	Branch on equal
BGEZ	Branch on greater than or equal to zero
BGEZAL	Branch on non-negative (>=0) and link r
BGTZ	Branch on greater than zero
BLEZ	Branch on less than or equal to zero
BLTZ	Branch on less than zero
BLTZAL	Branch on less than zero and link r
BNE	Branch on not equal
DIV	Divide
DIVU	Divide unsigned
J	Jump
JALR	Jump and link register r
JAL	Jump and link r
JR	Jump register
LB	Load byte r 
LBU	Load byte unsigned r
LH	Load half-word r
LHU	Load half-word unsigned r
LUI	Load upper immediate r
LW	Load word r
LWL	Load word left r
LWR	Load word right r
MTHI	Move to HI 
MTLO	Move to LO 
MULT	Multiply 
MULTU	Multiply unsigned
OR	Bitwise or r
ORI	Bitwise or immediate r
SB	Store byte
SH	Store half-word
SLL	Shift left logical
SLLV	Shift left logical variable
SLT	Set on less than (signed)
SLTI	Set on less than immediate (signed) r
SLTIU	Set on less than immediate unsigned 
SLTU	Set on less than unsigned r
SRA	Shift right arithmetic r
SRAV	Shift right arithmetic r
SRL	Shift right logical r
SRLV	Shift right logical variable r
SUBU	Subtract unsigned r
SW	Store word
XOR	Bitwise exclusive or r
XORI	Bitwise exclusive or immediate r


// 
opcode = 0 and not mthi mtlo

op rs rt rd

Type	31:26	25:21	20:16	15:11	10:06	05:00
R-Type	opcode	$rs	    $rt	    $rd	    shamt	funct
I-Type	opcode	$rs	    $rt	    imm
J-Type	opcode	address
