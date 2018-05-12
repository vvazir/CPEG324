import sys
opcode = "00000000"
skip = False
if (len(sys.argv)==2):
    opcodes = sys.argv[1]
elif (len(sys.argv)==3):
    opcodes = sys.argv[1]
    skip = (sys.argv[2]=="-s")
else:
    opcodes = [x for x in sys.stdin][0]
def chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]
opcodes = chunks(opcodes,8)

for opcode in opcodes:
    op0 = int(opcode[7])
    op1 = int(opcode[6])
    op6 = int(opcode[1])
    op7 = int(opcode[0])
    
    Write_EN = int(not(op6 and op7) and not skip)
    S_EN =int(op7 and not op6)
    IMM_EN =int(not op6 and not op7)
    CMP_EN =int(op6 and op7 and (op0 ^ op1))
    part1 =op6 and op7
    part2 =op1 ^ op0
    part3 =part1 and not part2
    part4 =part3 and not skip
    DISP_EN =int(part4)
    LOD =int(not(op6 or op7))
    print(opcode)
    print("Write_EN = {}\n2S_EN = {}\nIMM_EN = {}\nCMP_EN = {}\nDISP_EN = {}\nLOD = {}".format(Write_EN,S_EN,IMM_EN,CMP_EN,DISP_EN,LOD))
    print()