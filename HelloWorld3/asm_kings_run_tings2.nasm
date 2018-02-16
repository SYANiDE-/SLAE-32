; asm_kings_run_tings.nasm
; author: Chase Hatch


section .text
global _start
_start:

	; print the string
	xor eax, eax	;zero eax.. without having to hard-code 0x00!
	mov al, 0x4
	xor ebx, ebx
	mov bl, 0x1
	xor ecx, ecx
	jmp short string1
Echo:
	pop ecx
	xor edx, edx
	mov dl, 0x15
	int 0x80

	; exit cleanly
	xor eax, eax
	mov al, 0x1
	xor ebx, ebx
	int 0x80

string1:
	call Echo
	akrt:		db	"ASM Kings run tings!", 0x0a

