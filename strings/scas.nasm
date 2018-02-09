; scas.nasm
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

	; this is a mind bender section.
	; now we'll search for substring in string
	mov ecx, HWStrLen
	cld
	mov al, [Substring1]
	lea di, [HWStr]
	repne	scasb			;repeat while equal, compare bytes until not equal
	
	;;;, compares two bytes by subtracting the destination byte, pointed to by ES:DI
	;;;, from AL.  Obviously, if the bytes are equal, the result will be zero.





	;determine whether substring is in string and jump to print status procedure
	je SetE				;jump to SetE if equal (equal based on last operation, which is find)	
	jne SetNE			;jump to SetNE if not equal (not equal based on last operation, which is find)


section .data
	HWStr		db	"Hello ASM World!", 0x0a
	HWStrLen	equ	$-HWStr
	Substring1	db	"M"	
	Substring2	db	"X"
	Substring1Len	equ	$-Substring1	
	Substring2Len	equ	$-Substring2
	StatStr1	db	"Substring found in string!", 0x0a
	StatStr1Len	equ	$-StatStr1
	StatStr2	db	"Substring NOT found in string!", 0x0a
	StatStr2Len	equ	$-StatStr2


section .bss
	dest_str:	resb 	100


