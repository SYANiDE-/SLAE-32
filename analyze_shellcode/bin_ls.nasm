; bin_ls.nasm
; Author: Chase Hatch

section .text
global _start
_start:

	xor eax, eax
	push eax
	push 0x736c2f2f 	;  sl// 
	push 0x6e69622f 	;  nib/
	mov dword ebx, esp
	push eax
	mov dword edx, esp
	push eax
	push ebx
	mov dword ecx, esp
	mov al, 0xb
	int 0x80
	
