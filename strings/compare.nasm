; compare1.nasm
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

SetE:
	mov ecx, StatStr1
	mov edx, StatStr1Len
	call Printer
	call Exiter

SetNE:
	mov ecx, StatStr2
	mov edx, StatStr2Len
	call Printer
	call Exiter

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
	;call Exiter

	; now we'll compare two strings.
	mov ecx, HWStrLen
	lea esi, [HWStr]
	lea edi, [FakeStr]
	repe	cmpsb			;repeat while equal, compare bytes until not equal

	;determine whether strings are equal or not and print
	jz SetE				;jump to SetE if zero (equal based on last operation)	
	jnz SetNE			;jump to SetNE if not zero (not equal based on last operation)


section .data
	HWStr		db	"Hello ASM World!", 0x0a
	HWStrLen	equ	$-HWStr
	FakeStr		db	"Hello ASN World!", 0x0a	;ASN not same as ASM
	StatStr1	db	"Strings are the same", 0x0a
	StatStr1Len	equ	$-StatStr1
	StatStr2	db	"Strings differ", 0x0a
	StatStr2Len	equ	$-StatStr2


section .bss
	dest_str:	resb 	100


