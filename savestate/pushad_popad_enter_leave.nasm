; pushad_popad.nasm
; Author:  Chase Hatch


section .text
global _start
	;testing pushad and popad before calling procedure,  within procedure pushing more
	;, data to the stack, exiting the procedure (to see if leaving the procedure
	;, leaves that in-procedure-pushed data on the stack and borks the popad on return),
	;, and popping the data back off the stack and into the registers.

TestProcedure:

	;; push frame pointer to stack
	; push ebp
	; mov ebp, esp
	enter 0, 0

	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, issue
	mov edx, issue_len
	int 0x80

	;; pop frame pointer off stack
	; mov esp, ebp
	; pop ebp
	leave
	ret

Exiter:
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

_start:
	mov ecx, 0x5
	
LoopingPart:

	;save register and flag state
	pushad
	pushfd

	call TestProcedure

	;restore flag and register state
	popfd
	popad
	loopnz LoopingPart	
	jmp Exiter

section .data
	issue: db "Hello World!", 0x0a
	issue_len equ	$-issue

