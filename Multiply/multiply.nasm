; multiply_8bit.nasm
; author Chase Hatch

global _start

section .text
_start:
	; unsigned r/m8 multiplication
	mov eax, 0x0
	mov al, 0x20
	mov bl, 0x3
	mul bl

	mov al, 0xff
	mul bl

	; unsigned r/m16 multiplication
	mov eax, 0x0
	mov ebx, 0x0
	mov ax, 0xff99
	mov bx, 0x0003
	; echo "ibase=16; obase=A; FF99 * 3" |bc
	; 196299
	; echo "ibase=10; obase=16; 196299" |bc
	; 2FECB
	mul bx

	; got to get you some exit.  Clean, like...
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

section .data
	var1:	db	0x00
	var2:	dw	0x0000
	var3:	dd	0x00000000


