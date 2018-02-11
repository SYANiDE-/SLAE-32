; nasm_libc_md5.nasm
; Author: Chase Hatch

extern printf, exit, MD5
global main
section .text

	;;; Looking for something similar to the following:
	;;; #include <stdlib.h>
	;;; #include <stdio.h>
	;;; #include <string.h>
	;;; #include <openssl/md5.h>
	;;; 
	;;; int main(){
	;;; 	unsigned char result[MD5_DIGEST_LENGTH];
	;;; 	unsigned char *c = "This is a test of the emergency broadcast system"; 
	;;; 	unsigned char *FmtStr1 = "%s";
	;;; 	unsigned char *FmtStr2 = "%02x";
	;;; 	unsigned char *FmtStr3 = "\n";
	;;; 	int i = 0;
	;;; 	printf(FmtStr1, c);
	;;; 	printf(FmtStr1, FmtStr3);
	;;; 	MD5(c, strlen(c), result);
	;;; 	while(i != MD5_DIGEST_LENGTH){
	;;; 		printf(FmtStr2, result[i]);
	;;; 		i++;
	;;; 	}
	;;; 	printf(FmtStr1, FmtStr3);
	;;; 	exit(0);
	;;; }
	;;; 
	;;; // gcc -g c_libc_md5.c -o c_libc_md5.elf -lssl -lcrypto
	;;; // output should be: 
	;;; // This is a test of the emergency broadcast system
	;;; // 2c2ac543af2c4975e98bd90ae7279a76


main:
	push c
	push FmtStr1
	call printf
	add esp, 0x4 * 2
	push FmtStr3
	push FmtStr1
	call printf
	add esp, 0x4 * 2

	push dword result2
	push dword strlen_c
	push c
	call MD5
	add esp, 0x4 * 3

	mov eax, 0x0
	mov ebx, dword [result2]
	mov al, bl
	mov ebx, i
	mov esi, 4
while:
	mov ecx, dword [i]
	cmp ecx, dword [MD5_DIGEST_LENGTH]
	jge EXITER

	mov edx, [ebx + esi]
	mov al, dl
	push dword eax
	push FmtStr2
	call printf
	add esp, 0x4 *3

	inc dword[i]
	inc esi
	jmp while
	

EXITER:
	push FmtStr3
	call printf
	push 0x0
	call exit


section .data
	c:			db	"This is a test of the emergency broadcast system", 0x0
	strlen_c:		equ	$-c-1
	FmtStr1:		db	"%s", 0x0
	FmtStr2:		dd	"%02x", 0x0
	FmtStr3:		dw	"", 0x0a
	i:			dd	0x0
	result2:		times 16 db  0x0
	MD5_DIGEST_LENGTH:	dd	16 	; constant from libssl/md5.h



	;;; #include <stdlib.h>
	;;; #include <stdio.h>
	;;; #include <openssl/md5.h>
	;;; 
	;;; int main(){
	;;; 	printf("%d\n", MD5_DIGEST_LENGTH);
	;;; 	exit(0);
	;;; }
	;;; 
	;;; // gcc -g tmp.o -o tmp.elf -lssl -lcrypto
	;;; // Outputs:
	;;; // 16


	

