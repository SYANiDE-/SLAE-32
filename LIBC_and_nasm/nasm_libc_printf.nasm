; nasm_libc_printf.nasm
; Author Chase Hatch
extern printf
extern exit

section .text
global main	


;;; Trying for something like the following:
;;; #include <stdlib.h>
;;; #include <stdio.h>
;;; 
;;; int main(){
;;; 	unsigned int i = 16614;  //0x40e6
;;; 	unsigned char *HWStr = ": Hello ASM World!";
;;; 	unsigned char *FmtStr = "%d%s\n";
;;; 	unsigned int Count;
;;; 	while(i-- != 0){
;;; 		Count++; 
;;; 		printf(FmtStr, Count, HWStr);
;;; 	}
;;; 	exit(0);
;;; }


; after calling a libc function, ESP will need to be restored
;, accounting for any pointers-to-variables pushed onto the stack
;, for the call.
;
; push three dword-sized pointers onto the stack; 
; two pointer-to-char(1,3) and a pointer-to-int(2):
;	push HWStr
;	push dword [Count]
;	push FmtStr
; call the libc function:
;	call printf
; restore ESP 
;	add esp, (0x4 * 3)  ; esp is 12 bytes higher after three pointers pushed to stack




main:
	mov ecx, 0x40e6		;16614
While:
	push ecx
	inc dword [Count]
	push HWStr		;pointer-to-char
	push dword [Count]	;dword pointer-to-int
	push FmtStr		;pointer-to-char
	call printf		
	add esp, (0x4 * 3)	;restore ESP; it's +3 dwords higher in mem
	pop ecx
	loopnz While
	; mov eax, 0x0a
	call exit

section .data
	;quoted are pointers-to-char, integers and hex are values
	HWStr		db	": Hello ASM World!", 0x0a, 0x0
	FmtStr		db	"%d%s", 0x0
	Count		dd	0

