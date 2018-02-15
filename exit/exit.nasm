; exit.nasm
; Author:  Chase Hatch

global _start
section .text
_start:

	;mov eax, 0x1
	;mov ebx, 0x0
	;int 0x80

;;; Gives disassembled instructions like:
;;; Note the null char opcodes!
;;; 8048060:	b8 01 00 00 00       	mov    eax,0x1
;;; 8048065:	bb 00 00 00 00       	mov    ebx,0x0
;;; 804806a:	cd 80                	int    0x80

	xor eax,eax  	; will implicitly zero out rather than having to hardcode 0x0
			;, in the instructions!
	mov al, 0x1	; set just al 0x1
	; mov ebx, 0x0	;just do away with obv. 0x00
	int 0x80

;;; Gives disassembled instructions like:
;;; Note NO NULL OPS!
;;;  8048060:	31 c0                	xor    eax,eax
;;;  8048062:	b0 01                	mov    al,0x1
;;;  8048064:	cd 80                	int    0x80


