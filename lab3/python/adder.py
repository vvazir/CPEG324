# -*- coding: utf-8 -*-
"""
Created on Thu Apr 26 11:03:17 2018

@author: Vinay
"""
import numpy as np

def add(x,y):
    carry = 0
    for i in range(len(x)-1,-1,-1):
        x[i] = x[i] + y[i] + carry
        carry,x[i] = divmod(x[i],2)
    return x
bits = 8
x = np.zeros(bits)
y = np.zeros(bits)
y[7] = 1
print(add(x,y))
print(add(x,y))
print(add(x,y))
print(add(x,y))
print(add(x,y))
