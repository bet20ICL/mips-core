opcode_dict = {
    "addiu": (0b001001, 4, None),
    "andi": (0b001100, 4, None),
    "ori": (0b001101, 4, None),
    "xori": (0b001110, 4, None),
}


# AND rd,rs,rt      0	
# SLL rd,rt,sa	    1
# DIV rs,rt	        2
# MFHI rd	        3
# ORI rt,rs,imm	    4
# LB rt,offset(rs)	5

radix_dict = {
    "x": 16,
    "b": 2,
    "d": 10
}

assembly = "addiu  $2, $4, 0x1001"

assembly = assembly.strip()

space = assembly.find(" ")

opcode = assembly[:space]
print(opcode)
op_bin, i_format, func = opcode_dict[opcode]
word = bin(op_bin)[2:].zfill(6)

rt = 0
rs = 0
rd = 0
imm = 0
shamt = 0

if i_format == 0:
    
elif i_format == 4:
    rt_s = assembly.find("$")
    rt_e = assembly.find(",")
    rt = bin(int(assembly[rt_s + 1:rt_e]))[2:].zfill(5)
    rs_s = assembly.find("$", rt_e + 1)
    rs_e = assembly.find(",", rs_s + 1)
    rs = bin(int(assembly[rs_s + 1:rs_e]))[2:].zfill(5)
    imm_s = assembly.find("0", rs_e + 1)
    radix = radix_dict[assembly[imm_s + 1]]
    imm = bin(int(assembly[(imm_s + 2):], radix))[2:].zfill(16)
    word = word + rt + rs + imm
# elif i_format == 0:

    
print(word)
    

