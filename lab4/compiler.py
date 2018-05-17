# -*- coding: utf-8 -*-
"""
Created on Thu Apr 26 11:48:37 2018

@author: Vinay
"""

import sys

def chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

if len(sys.argv)!=2:
    print("Invalid number of arguments")
    sys.exit(1)
binFile = sys.argv[1]
if not binFile.endswith('.jv'):
    print("Invalid file extension")
    print("Use the compiler created in lab 2 to create the binary file")
    print("Then run this program on it to create the vhdl file")
    sys.exit(1)
    
file = open(binFile,"r")
binCode = list(chunks(file.read(),8))
file.close()

base = open("base.vhdl","r")
header = binFile[:-3]
fileName = "calculator_$testName$_tb.vhdl".replace("$testName$",header)
newFile = []
patternStart = -1
for num,line in enumerate(base):
    newFile.append(line.replace("$testName$",header))
    if "$patterns$" in line:
        patternStart = num
base.close()

if (patternStart==-1):
    print("Error with the base file")
    sys.exit(1)

for i,line in enumerate(binCode):
    binCode[i] = "(\"" + binCode[i] + "\""
    zeroLine = binCode[i]
    binCode[i] = zeroLine + ", '0'),\n"
    binCode[i] = binCode[i] + zeroLine+", '1')"
    if i!=len(binCode)-1:
        binCode[i]= binCode[i] + ","
    else:
        binCode[i] = zeroLine + ", '0'),\n"
        binCode[i] += zeroLine + ", '1'),\n"
		
    binCode[i] += "-- At {} ns\n".format(i*2)
# Add two nop instructions to clear buffer
binCode.append('-- Add NOP instructions to clear the pipeline\n')
binCode.append('(\"11000011\", \'0\'),\n')
binCode.append('(\"11000011\", \'1\'),\n')
binCode.append('(\"11000011\", \'0\'),\n')
binCode.append('(\"11000011\", \'1\')\n')
file = open(fileName,"w")
for line in newFile[:patternStart]+binCode+newFile[patternStart+1:]:
    file.write(line)
file.close()
