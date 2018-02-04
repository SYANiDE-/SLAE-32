; multiply3.nasm
; author Chase Hatch

section .text
global _start
_start:
	; unsigned multiply with unsigned values
	; this was correct
	mov eax, 0x12	;18
	mov ebx, 0x3	;3
	mul ebx		;54 or eax(0x36)
		;$43 = 0x36
		;$44 = 0x3
		;$45 = 0x0
		;$46 = 0x0
		;$47 = [ PF IF ]
		;	print/d $eax
		;	= 54

	; unsigned multiply with a signed value
	; this was so wrong.
	mov edx, 0x0
	mov eax, 0x12	;18
	mov ebx, -3	;0xfffffffd
	mul ebx		;expect -54 or eax(0x36)
		;$21 = 0xffffffca	;this is wrong... should have been 0x36
		;$22 = 0xfffffffd
		;$23 = 0x0
		;$24 = 0x11
		;$25 = [ CF PF SF IF OF ]
		;	print/d $eax
		;	= -54,  wrong.  Expected positive by convention but logically this is right.
		;	print/d ($eax - $edx) -1
		;	= -72 because (-54 - 17) -1 == -72


	; signed multiply with signed numbers
	; this is correct
	mov edx, 0x0
	mov eax, 0x12	;18
	mov ebx, -3	;0xfffffffd
	imul ebx	;expect -54 or eax(0xffffffca)
		;$41 = 0xffffffca
		;$42 = 0xfffffffd
		;$43 = 0x0
		;$44 = 0xffffffff
		;$45 = [ PF SF IF ]
		;	print/d ($eax - $edx)-1
		;	= -54

	; exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80




