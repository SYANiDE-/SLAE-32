; and_or_xor_not.nasm
; Author: Chase Hatch


section .text
global _start
_start:

	; AND
	mov eax, 0x2	;00000010
	mov ebx, 0x4	;00000100 
	and eax, ebx	;00000000 ; 0x0  0  expected
			;, because binary 2 and binary 4 share no bits.
		;$16 = 0x0
		;$17 = 0x4
		;$18 = 0x0
		;$19 = 0x0
		;$20 = [ PF ZF IF ]	

	
	; AND
	mov eax, 0x1167		;echo "ibase=16; obase=2; 1167" |bc
				;1000101100111 ; 4455
	mov ebx, 0x1317		;echo "ibase=16; obase=2; 1317" |bc
				;1001100010111 ; 4887
	and eax, ebx		;1000100000111 ; 4359  0x1107 	expected
		;$31 = 0x1107
		;$32 = 0x1317
		;$33 = 0x0
		;$34 = 0x0
		;$35 = [ IF ]
		;print/d $eax == 4359
		;print/x $eax == 0x1107
		;print/t $eax == 1000100000111


	; OR
	mov eax, 0x1167		;1000101100111 ; 4455
	mov ebx, 0x1317		;1001100010111 ; 4867
	or eax, ebx		;1001101110111 ; 4983  0x1377   expected
		;$6 = 0x1377
		;$7 = 0x1317
		;$8 = 0x0
		;$9 = 0x0
		;$10 = [ PF IF ]
		;print/d $eax == 4983
		;print/x $eax == 0x1377
		;print/t $eax == 1001101110111


	; XOR
	mov eax, 0x1167         ;1000101100111 ; 4455
        mov ebx, 0x1317         ;1001100010111 ; 4867
	push eax
	push ebx
	xor eax, ebx		;0001001110000 ; 624  0x270   expected
	push eax
		;$eax = 0x270
		;$ebx = 0x1317
		;$ecx = 0x0
		;$edx = 0x0
		;$16 = [ IF ]
		;print/d $eax == 624
		;print/x $eax == 0x270
		;print/t $eax == 0001001110000
		;				varC		varB		varA
		;x/3xw $esp: 0xbffff414:	0x00000270	0x00001317	0x00001167
	pop dword [varC]
	pop dword [varB]
	pop dword [varA]
	mov eax, 0x0
	mov ebx, 0x0
	mov ecx, 0x0
	add eax, dword [varC]
	xor eax, dword [varB]	;varA
	push eax
	mov eax, 0x0
	add eax, dword [varC]
	xor eax, dword [varA]  	;varB
	push eax
	mov eax, 0x0
	mov eax, dword [varA]
	xor eax, dword [varB]	;varC
	push eax
		;				varC		varB		varA
		;x/3xw $esp: 0xbffff414:	0x00000270	0x00001317	0x00001167


	; NOT
	; result is bitwise-inverse of the NOT operand
	; if for bit position in operand = 1, bit position in result = 0
	; if for bit position in operand = 0, bit position in result = 1
	mov eax, 0x1167         ;1000101100111 ; 4455
	not eax			;0111010011000 ; 3736  0xE98  expected
		;before:
		;$eax = 0x1167
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$1 = [ IF ]
		;print/d $eax = 4455
		;print/x $eax = 0x1167
		;$2 = 1000101100111
		;# 13 bits len

		;after:
		;$eax = 0xffffee98
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$6 = [ IF ]
		;print/d $eax = -4456
		;print/x $eax = 0xffffee98
		;$7 = 11111111111111111110111010011000
		;# last 13 bits:
		;     0111010011000


	;exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


section .data
	varA:		dd	0x0
	varB:		dd	0x0
	varC:		dd	0x0


