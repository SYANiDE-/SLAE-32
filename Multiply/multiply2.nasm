; multiply2.nasm
; author Chase Hatch

global _start
section .text
_start:

	; mov eax, 0xffff0001
	; mov ebx, 0x2
	; mul ebx

		;$eax = 0xfffe0002
		;$ebx = 0x2
		;$ecx = 0x0
		;$edx = 0x1
		;$eflags = [ CF SF IF OF ]

	;mov eax, 0x0
	;mov ebx, 0x0
	;mov edx, 0x0
	
	mov eax, 0xffff0001
	mov ebx, 0x2
	imul eax, ebx

		;$eax = 0xfffe0002
		;$ebx = 0x2
		;$ecx = 0x0
		;$edx = 0x0
		;$eflags = [ SF IF ]


	; clean exit
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80
