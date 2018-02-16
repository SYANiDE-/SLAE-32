; asm_kings_run_tings.nasm
; author: Chase Hatch


section .text
global _start
_start:

	; print the string
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, akrt
	mov edx, akrt_len
	int 0x80

	; exit cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

section .data
	akrt:		db	"ASM Kings run tings!", 0x0a
	akrt_len	equ	$-akrt

