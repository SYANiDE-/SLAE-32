; datatypes.nasm
; written by Chase Hatch

global _start

section .text
_start:
	; print "I am a spatula" to screen
	mov eax, 0x04
	mov ebx, 0x1
	mov ecx, spatula_text
	mov edx, spa_tex_len
	int 0x80

	; exit cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


section .data
	vara:		db 0xaa
	varb:		db 0xbb, 0xcc, 0xdd
	varc:		dw 0xee
	vard:		dd 0xaabbccdd
	vare:		dd 0x112233
	varf:		TIMES 6 db 0xff

	spatula_text: dd "I am a spatula.  Time to spat!", 0x0a
	spa_tex_len equ $-spatula_text

section .bss
	varg:		resb 100
	varh:		resw 20


