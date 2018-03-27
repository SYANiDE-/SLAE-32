section .text
global _start
_start:

	mov eax, 0xffffffff
	mov edx, 0xffffffff
	stc
	cdq
	mov al, 0x1
	mov bl, 0x0
	int 0x80
