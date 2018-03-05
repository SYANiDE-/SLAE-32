#include <stdio.h>
#include <string.h>
// gcc -fno-stack-protector -z execstack executor.c -o executor.elf

char shellcode [] =\
"\x90\x55\x89\xe5\x8b\x7d\x0c\xb0\x01\xcd\x80";

int main(int argc, char **argv[]){
	(* (int (*)())shellcode)();
}
