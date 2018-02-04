; divide3.nasm
; http://www.godevtool.com/TestbugHelp/UseofIDIV.htm  
; author  NOT EQUALS CHASE HATCH on logic,  EQUALS CHASE HATCH on structure

global _start
section .text
_start:
	;********************* IDIV demonstration
	;*********** divide -21 by 5 result should be -4 remainder -1
	;****** byte operation
	MOV AX,-21             ;put -21 into AX for dividend
	MOV BH,5               ;put 5 into BH for divisor
	IDIV BH                ;divide AX by BH: AL=-4, AH=-1 - correct
	;****** word operation
	MOV DX,-1              ;sign extend -21 into higher order dividend
	MOV AX,-21             ;put -21 into AX for lower order dividend
	MOV BX,5               ;put 5 into BX for divisor
	IDIV BX                ;divide DX:AX by BX: AX=-4, DX=-1 - correct
	;****** dword operation
	MOV EDX,-1             ;sign extend -21 into higher order dividend
	MOV EAX,-21            ;put -21 into EAX
	MOV EBX,5              ;put 5 into EBX for divisor
	IDIV EBX               ;divide EDX:EAX by EBX: EAX=-4, EDX=-1 - correct
	;*********** divide -21 by -5 result should be +4 remainder -1
	;****** byte operation
	MOV AX,-21             ;put -21 into AX for dividend
	MOV BH,-5              ;put -5 into BH for divisor
	IDIV BH                ;divide AX by BH: AL=4, AH=-1 - correct
	;****** word operation
	MOV DX,-1              ;sign extend -21 into higher order dividend
	MOV AX,-21             ;put -21 into AX for lower order dividend
	MOV BX,-5              ;put -5 into BX for divisor
	IDIV BX                ;divide DX:AX by BX: AX=4, DX=-1 - correct
	;****** dword operation
	MOV EDX,-1             ;sign extend -21 into higher order dividend
	MOV EAX,-21            ;put -21 into EAX
	MOV EBX,-5             ;put -5 into EBX for divisor
	IDIV EBX               ;divide EDX:EAX by EBX: EAX=4, EDX=-1 - correct
	;*********** divide +21 by -5 result should be -4 remainder +1
	;****** byte operation
	MOV AX,21              ;put 21 into AX for dividend
	MOV BH,-5              ;put -5 into BH for divisor
	IDIV BH                ;divide AX by BH: AL=-4, AH=1 - correct
	;****** word operation
	MOV DX,0               ;sign extend 21 into higher order dividend
	MOV AX,21              ;put 21 into AX for lower order dividend
	MOV BX,-5              ;put -5 into BX for divisor
	IDIV BX                ;divide DX:AX by BX: AX=-4, DX=1 - correct
	;****** dword operation
	MOV EDX,0              ;sign extend 21 into higher order dividend
	MOV EAX,21             ;put 21 into EAX
	MOV EBX,-5             ;put -5 into EBX for divisor
	IDIV EBX               ;divide EDX:EAX by EBX: EAX=-4, EDX=1 - correct

