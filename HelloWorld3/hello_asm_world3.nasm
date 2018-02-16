; hello_asm_world.asm
; Author: Chase Hatch

global _start

section .text
_start:
	; prints "Hello ASM World!" to stdout(1)
	xor eax, eax
	mov al, 0x4
	xor ebx, ebx
	mov bl, 0x1
	jmp short CALL_SC
	;; mov ecx, somelabel

shellcode:
	pop ecx
	xor edx, edx
	mov dl, 0x17 
	int 0x80    

	
	; exits cleanly
	xor eax, eax
	mov al, 0x1
	xor ebx, ebx
	int 0x80

CALL_SC:
	call shellcode
	somelabel: 	db 	"Hello ASM World!", 0x0a 

