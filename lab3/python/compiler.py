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
print(binCode)
