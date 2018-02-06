; HelloWorld2.nasm
; Author:  Chase Hatch

section .text
global _start
_start:
	; LOOPNZ - decrements CX by 1 (without modifying the flags) and 
	;, transfers control to "label" If CX !=0. and zero flag is clear.
	;, Label operand must be within -128 or +127 bytes of the instruction
	;, following the loop instruction.
	mov ecx, 0x5
	
Looping:
	push ecx   ; push curval onto stack

	; print a string to output $esi more times
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, HWStr
	mov edx, HWStrLen
	int 0x80

	; grab the curval off the stack and decrement it, start from the top if not zero.	
	pop	ecx
	; dec	eax   ; I think the LOOPNZ instruction will do this for us.
	LOOPNZ Looping

	; end
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


section .data
	HWStr:		db 	"Hello World!", 0x0a
	HWStrLen 	equ	$-HWStr
	
