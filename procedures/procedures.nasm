; procedures.nasm
;Author: Chase Hatch


section .text
global _start

Printer:
	mov eax, 0x4			;write(stdout, str, len)  SYSCALL
	mov ebx, 0x1			;stdout fd
	;mov ecx, <whatever item>	;handled by calling procedure
	;mov edx, <item len>		;handled by calling procedure
	int 0x80			;SYSCALL
	ret				;return from procedure "Printer"

PrintCounter:
	mov ecx, 0x0			;zero ecx counter register
	mov ecx, [Counter]		;move memory contents of Counter to ecx
	inc ecx				;increment ecx
	mov [Counter], ecx		;move ecx to memory contents of Counter
	mov ecx, Counter
	mov edx, CounterLen
	call Printer
	ret

PrintHWStr:
	mov ecx, HelloWorldStr
	mov edx, HelloWorldStrLen
	call Printer
	ret

LineBreaker:
	mov ecx, LineBrk
	mov edx, LineBrkLen
	call Printer
	ret

Exiter:
	mov eax, 0x1
	mov ebx, 0x0
	int 0x80


;; This is where the Main() magic happens...
_start:
	mov ecx, 0x5
Repeater:
	push ecx
	call PrintCounter
	call PrintHWStr
	call LineBreaker
	pop ecx
	loopnz Repeater
	jmp Exiter

section .data
	Counter:		db	"0"
	CounterLen		equ	$-Counter
	HelloWorldStr: 		db 	": Hello ASM World!"
	HelloWorldStrLen 	equ 	$-HelloWorldStr
	LineBrk:		db	0x0a
	LineBrkLen		equ	$-LineBrk

