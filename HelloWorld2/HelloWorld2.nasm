; HelloWorld2.nasm
; Author:  Chase Hatch

section .text
global _start
_start:
	mov eax, 0x5
	
Looping:
	push eax   ; push curval eax on stack

	; print a string to output $esi more times
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, HWStr
	mov edx, HWStrLen
	int 0x80

	; grab the curval off the stack and decrement it, start from the top if not zero.	
	pop	eax
	dec	eax
	JNZ Looping

	; end
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


section .data
	HWStr:		db 	"Hello World!", 0x0a
	HWStrLen 	equ	$-HWStr
	
