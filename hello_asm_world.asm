; hello_asm_world.asm
; Author: Chase Hatch

global _start

section .text
_start:
	; prints "Hello ASM World!" to stdout(1)
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, somelabel
	mov edx, somelabellen 
	int 0x80    

	
	; exits cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


section .data
	somelabel: 	db 	"Hello ASM World!", 0x0a, "ASM kings run tings!", 0x0a
	somelabellen	equ	$-somelabel

