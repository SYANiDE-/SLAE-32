#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// gcc hello_world.c -o hello_world.elf -fno-stack-protector -z execstack

char shellcode[]=\
"Hello World!\n";

void main(int argc, char **argv[]){
	printf("[#] len %d bytes\n", strlen(shellcode));
	printf("[#] %s", shellcode);
	exit(0);	
}

