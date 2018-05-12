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
vcd = ".vcd"
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
	subprocess.run(['ghdl','-a','--ieee=standard',comp+ext],shell=True)
print (tb)
subprocess.run(['ghdl','-a','--ieee=standard',testBench],shell=True)
subprocess.run(['ghdl','-e','--ieee=standard',tb],shell=True)
subprocess.run(['ghdl','-r','--ieee=standard',tb,'--vcd='+tb+vcd],shell=True)
if (show):
	subprocess.run(['gtkwave',tb+vcd],shell=True)
