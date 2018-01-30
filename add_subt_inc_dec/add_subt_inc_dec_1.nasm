; add_subt_inc_dec.nasm
; author: Chase Hatch


global _start
section .text
_start:
	mov eax, 0x0
	mov eax, 0xffffffff
	adc eax, 0x1
	sbb eax, 0x1
	add byte [var1], 0x22
	add byte [var1], 0x33
	add word [var2], 0x1234
	add word [var2], 0x1234
	mov dword [var3], 0xffffffff
	adc dword [var3], 0x10
	sbb dword [var3], 0x10
	push eax
	push eax
	push dword [var3]
	inc eax
	inc eax
	dec eax
	pop eax
	pop eax
	
	; exit cleanly
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

section .data
	var1: db 0x00
	var2: dw 0x0000
	var3: dd 0x00000000
