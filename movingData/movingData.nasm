; movingData.nasm
; author:  Chase Hatch

global _start
section .text
_start:
	; mov data into registers
	mov ebx, 0xaaaaaaaa
	mov ecx, 0xbbbb
	mov dl, 0xcc
	mov dh, 0xdd
	mov eax, 0
	mov eax, 1

	; mov reg to reg
	mov eax, ebx
	mov cl, dl
	mov ch, dh

	; mov from mem to reg
	mov al, [spam]
	mov ah, [spam +1]
	mov bx, [spam]
	mov ecx, [spam +4]

	; mov reg to mem
	mov eax, 0x33445566
	mov byte [spam], al
	mov word [spam +5], 0xff
	mov dword [spam], ebx

	; immediate val to mem
	mov dword [spam], 0xdeadbeef
	
	;lea load effective address
	lea eax, [spam]
	lea ebx, [eax]

	; xchg
	xchg ebx, [spam]
	xchg [spam], edx

	; exit cleanly
	mov eax, 0x01
	mov ebx, 0x00
	int 0x80


section .data
	spam: 		db 	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
	spam_len 	equ	$-spam
	
