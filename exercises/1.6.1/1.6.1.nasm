; 1.6.1.nasm
; Author:  Chase Hatch

global _start
section .text
_start:
	push 0xdeadbeef
	push 0x69
	push 0x49
	push 0x29
	pop edx
	pop ecx
	pop ebx
	pop eax

	; exit cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

section .data
	orphan: db "orphaned"


