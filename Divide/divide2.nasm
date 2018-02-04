; divide2.nasm
; author:  Chase Hatch

global _start
section .text
_start:

	; divide
	mov eax, 0xffff0001
	mov ebx, 0x2
	div ebx

		;$16 = 0x7fff8000
		;$17 = 0x2
		;$18 = 0x0
		;$19 = 0x1
		;$20 = [ IF ]

	; reset registers
	mov eax, 0x0
	mov ebx, 0x0
	mov ecx, 0x0
	mov edx, 0x0
	clc	;clear carry flag

	; divide signed
	mov eax, 0xffff0001
	mov ebx, 0x2
	idiv ebx
	
		;$41 = 0x7fff8000
		;$42 = 0x2
		;$43 = 0x0
		;$44 = 0x1
		;$45 = [ IF ]

	; reset registers
	mov eax, 0x0
	mov ebx, 0x0
	mov ecx, 0x0
	mov edx, 0x0
	clc	;clear carry flag

	; divide signed;  trying to get that EDX:EAX / EBX though
	mov eax, -26
	mov ebx, 2
	mov edx, -1 	; something about sign-extending eax into higher-order dividend
	idiv ebx	; expected output should be EDX(0xffffffff or -1):EAX(0xd or 13)
			; -13 effective

		; with EIP == idiv ebx:
		;$16 = 0xffffffe6
		;$17 = 0x2
		;$18 = 0x0
		;$19 = 0xffffffff
		;$20 = [ IF ]


		; stepi EIP == idiv ebx:
		;$41 = 0xfffffff3
		;$42 = 0x2
		;$43 = 0x0
		;$44 = 0x0
		;$45 = [ IF ]

	; reset registers
	mov eax, 0x0
	mov ebx, 0x0
	mov ecx, 0x0
	mov edx, 0x0
	clc


	; divide signed;  trying to get that EDX:EAX / EBX though
	mov ax, -26
	mov bx, 2
	mov dx, -1 	; something about sign-extending eax into higher-order dividend
	idiv bx	; expected output should be EDX(0xffffffff or -1):EAX(0xd or 13)
			; -13 effective

					
	; exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80
