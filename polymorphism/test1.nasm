; test.nasm testing
; Author: Chase Hatch

section .text
global _start
_start:
	push 0x11223344
	fldz
	fstenv [dz]
	pop ecx

	mov al, 0x1
	mov bl, 0x0
	int 0x80

section .bss
	dz:	resb	28

