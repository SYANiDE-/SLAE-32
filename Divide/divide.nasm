; divide.nasm
; author Chase Hatch

global _start
section .text
_start:

	; r/m8 division
	mov al, 0x13    ;19
	mov bl, 0x2
	div bl
	
	; r/m16 division
	mov ax, 0x1123	;4,387
	mov bx, 0x2
	div bx		;0x891  or 2,193.5

	; r/m32 division
	mov eax, 0x113333  	;1,127,209
	mov ebx, 0x2
	mov edx, 0x0
	div ebx			;0x89999 or 563,609
	
	; another EDXEAX / 32-bit
	mov eax, 0x23232323	;589,505,315
	mov ebx, 0x121112	;1,184,018
	mov ecx, 0x0
	mov edx, 0x0
	div ebx		;EAX(0x1f1 497), EDX(0xfff31  1,048,369)

	; exit cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80



