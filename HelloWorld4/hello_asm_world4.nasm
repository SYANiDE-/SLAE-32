; hello_asm_world4.asm
; Author: Chase Hatch

global _start

section .text
_start:
	; prints "Hello ASM World!" to stdout(1)
	xor eax, eax
	mov al, 0x4
	xor ebx, ebx
	push ebx
	mov bl, 0x1

push 0x0a217367 
push 0x6e697420 
push 0x6e757220 
push 0x73676e69 
push 0x4b204d53 
push 0x410a2164 
push 0x6c726f57 
push 0x206f6c6c 
push 0x65480820			; 08 20 = space, backspace, in rev
				; not exactly clean, but output is clean
	mov ecx, esp
	
	xor edx, edx
	mov dl, 0x24
	int 0x80    

	
	; exits cleanly
	xor eax, eax
	mov al, 0x1
	xor ebx, ebx
	int 0x80


