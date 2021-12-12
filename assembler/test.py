num = 1034
print(bin(num))
print("hello world")

opcode_dict = {
    "addiu": (0b001001, 1),
    "andi": (0b001100, 1),
    "ori": (0b001101, 1),
    "xori": (0b001110, 1),
}

radix_dict = {
    "x": 16,
    "b": 2,
    "d": 10
}

input = "addiu  $2, $4, 0x1234"

input = input.strip()

space = input.find(" ")

opcode = input[:space]
print(opcode)
bin, type = opcode_dict[opcode]
word = ""
word += opcode

rt = 0
rs = 0
rd = 0
imm = 0
shamt = 0
func = 0

if type == 1:
    rt_s = input.find("$")
    rt_e = input.find(",")
    rt = int(input[rt_s + 1:rt_e])
    rs_s = input.find("$", rt_e + 1)
    rs_e = input.find(",", rs_s + 1)
    rs = int(input[rs_s + 1:rs_e])
    imm_s = input.find("0", rs_e + 1)
    radix = radix_dict[input[imm_s + 1]]
    imm_int = int(input[(imm_s + 2):], radix)
    # tmp = bin(int(input[(imm_s + 2):], radix))[2:].zfill(16)
print(bin(123))
print(imm)