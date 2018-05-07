#usr/bin/python3
import os
import sys
import subprocess
testBench = sys.argv[1]
show = False
if len(sys.argv)>2:
	if (sys.argv[2]=='-s'):
		show = True
ext = ".vhdl"
tb = testBench[:-3]
vcd = tb+".vcd"
vhdlTB = "calculator_{}_tb".format(tb)
# vhdl file names
components=[
	"calculator",
	"compliment",
	"control",
	"eightBitAdder",
	"flip",
	"mux",
	"regMem",
	"shift_reg",
	"sign_extend",
	"zeroCheck"
]
for comp in components:
	subprocess.run('ghdl -a --ieee=standard {}'.format(comp+ext),shell=True)
subprocess.run('python compiler.py {}'.format(testBench),shell = True)
subprocess.run('ghdl -a --ieee=standard {}'.format(vhdlTB+ext),shell=True)
subprocess.run('ghdl -e --ieee=standard {}'.format(vhdlTB),shell=True)
subprocess.run('ghdl -r --ieee=standard {} --vcd={}'.format(vhdlTB,vcd),shell=True)
if (show):
	subprocess.run('gtkwave {}'.format(vcd),shell=True)
