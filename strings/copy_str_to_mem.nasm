; copy_str_to_mem.nasm
; Author: Chase Hatch


section .text
global _start

Printer:
	enter 0,0
	mov eax, 0x4
	mov ebx, 0x1
	;mov ecx, (string)
	;mov edx, (length)
	int 0x80
	leave
	ret

Exiter:
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

_start:

	; copy string from Source 
	;, to destination
	mov ecx, HWStrLen		;Source string length
	lea esi, [HWStr]		;Source string
	lea edi, [dest_str]		;Destination string
	cld				;clear direction flag so 
	rep	movsb			;repeat the movsb operation until zero condition met

	; print the string back
	pushad
	pushfd
	mov ecx, dest_str
	mov edx, HWStrLen
	call Printer
	popfd
	popad
	call Exiter


section .data
	HWStr		db	"Hello ASM World!", 0x0a
	HWStrLen	equ	$-HWStr
	FakeStr		db	"Hello ASN World!", 0x0a
	StatStr1	db	"Strings are the same", 0x0a
	StatStr1Len	equ	$-StatStr1
	StatStr2	db	"Strings differ", 0x0a
	StatStr2Len	equ	$-StatStr2


section .bss
	dest_str:	resb 	100
