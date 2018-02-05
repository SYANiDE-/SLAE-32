; sar_shr_ror_lol.nasm
; Author:  Chase Hatch

section .text
global _start
_start:
	; SAR - Shift Arithmetic Right
	; sar r/m32 - signed divide r/m32 by 2, x times.
	; Not the same form of division as IDIV; rounding is toward negative infinity.
	; https://c9x.me/x86/html/file_module_x86_id_285.html
	mov eax, 0xA245		; 41541 	1010001001000101
	sar eax, 1		; 20770r1	0x5122	101000100100010 	expected
		;$eax = 0x5122
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$11 = [ CF PF IF ]
		;print/d $eax = 20770
		;print/x $eax = 0x5122
		;$12 = 101000100100010

	; same as above, but SAR was meant for SIGNED divide r/m[8,16,32] by 2, xtimes
	mov eax, 0xffff5dbb	; -41541   	
				;11111111111111110101110110111011
	sar eax, 1		; -20771	0xFFFFFFFFFFFAEDD	
				;11111111111111111010111011011101
		;$eax = 0xffffaedd
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$11 = [ CF PF SF IF ]
		;print/d $eax = -20771
		;print/x $eax = 0xffffaedd
		;$12 = 	11111111111111111010111011011101

	
	; SHR - UNSIGNED power-of-two division
	mov eax, 0xa245
	shr eax, 1	
		;$eax = 0x5122
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$11 = [ CF PF IF ]
		;print/d $eax = 20770
		;print/x $eax = 0x5122
		;$12 = 101000100100010


	; ROL - Rotate left
	mov eax, 0xa245
	clc
	rol eax, 2
		;before:
		;$eax = 0xa245
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$6 = [ PF IF ]
		;print/d $eax = 41541
		;print/x $eax = 0xa245
		;$7 = 1010001001000101

		;after:
		;$eax = 0x28914
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$11 = [ PF IF ]
		;print/d $eax = 166164
		;print/x $eax = 0x28914
		;$12 = 101000100100010100



	; ROR - Rotate right
	mov eax, 0xa245
	clc
	ror eax, 2

                ;before:
                ;$eax = 0xa245
                ;$ebx = 0x0
                ;$ecx = 0x0
                ;$edx = 0x0
                ;$6 = [ PF IF ]
                ;print/d $eax = 41541
                ;print/x $eax = 0xa245
                ;$7 = 1010001001000101

		;after:
		;$eax = 0x40002891
		;$ebx = 0x0
		;$ecx = 0x0
		;$edx = 0x0
		;$21 = [ PF IF ]
		;print/d $eax = 1073752209
		;print/x $eax = 0x40002891
		;$22 = 1000000000000000010100010010001


	; exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80
  
