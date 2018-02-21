; divide4.nasm
; author: Chase Hatch

section .text
global _start
_start:
	mov eax, 0x36	;54
	mov ebx, -2	;0xfffffffe
	idiv ebx	;expect eax(-27 or 0xffffffe5)
		;$16 = 0xffffffe5
		;$17 = 0xfffffffe
		;$18 = 0x0
		;$19 = 0x0
		;$20 = [ IF ]
		;	print/d $eax
		;	= -27

	;exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

