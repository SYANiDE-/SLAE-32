; execve.nasm
; Author:  Chase Hatch

section .text
global _start
_start:
	jmp short EXECVE
alpha:
	pop esi
	xor eax, eax
	mov byte [esi+9], al
	mov dword [esi+10], eax
	mov dword [esi+14], eax
	mov al, 0xb		;syscall 11 execve
	lea ebx, [esi]
	lea ecx, [esi+10]
	lea edx, [esi+14]
	int 0x80

EXECVE:
	call alpha
	execve_msg		db	"/bin/bashABBBBCCCC"
