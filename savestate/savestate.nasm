; savestate.nasm
;Author: Chase Hatch


section .text
global _start

Printer:
	enter 0,0
	mov eax, 0x4
	mov ebx, 0x1
	;mov ecx	;set by caller
	;mov edx	;set by caller
	int 0x80
	leave
	ret

PrintCount:
	enter 0,0
	inc byte [Counter]
	mov ecx, Counter
	mov edx, CounterLen
	pushad
	pushfd
	call Printer
	popfd
	popad
	leave
	ret

PrintStr:
	enter 0,0
	mov ecx, HelloWorldStr
	mov edx, HelloWorldStrLen
	pushad
	pushfd
	call Printer
	popfd
	popad
	leave
	ret

PrintLB:
	enter 0,0
	mov ecx, LineBreak
	mov edx, LineBreakLen
	pushad
	pushfd
	call Printer
	popfd
	popad
	leave
	ret

Exiter:
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


_start:
	mov ecx, 0x9
Looper:
	pushad
	pushfd
	call PrintCount
	call PrintStr
	call PrintLB
	popfd
	popad
	loopnz Looper
	jmp Exiter

section .data
	Counter:		db	"0"
	CounterLen		equ	$-Counter
	HelloWorldStr:		db	": Hello World!"
	HelloWorldStrLen	equ	$-HelloWorldStr
	LineBreak:		db	0x0a
	LineBreakLen		equ	$-LineBreak


