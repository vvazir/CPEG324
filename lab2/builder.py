#usr/bin/env
import os
import sys
import subprocess
vhdl = sys.argv[1]
ext = ".vhdl"
tb = vhdl+"_tb"
vcd = ".vcd"
subprocess.run(['ghdl','-a',vhdl+ext],shell=True)
subprocess.run(['ghdl','-e',vhdl],shell=True)
subprocess.run(['ghdl','-a',tb+ext],shell=True)
subprocess.run(['ghdl','-e',tb],shell=True)
subprocess.run(['ghdl','-r',tb,'--vcd='+tb+vcd],shell=True)
subprocess.run(['gtkwave',tb+vcd],shell=True)
