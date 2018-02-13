#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// array needs to be global for __asm__ to access
unsigned char shellcode[9999], *sc;


unsigned char* sc_via_cli_arg(char **argv){
	// Shamelessly ripped from https://gist.github.com/xsleonard/7341172
	//, and nao it's mein moar and thanxu.
	unsigned char localize[strlen(argv[1])];
	strcpy(localize, argv[1]);
	int len = strlen(argv[1]);
	int end_len = len/4;
	int i=0;
	int j=0;
	unsigned char* BYTEZ = (unsigned char*)malloc((end_len +1) * sizeof(*BYTEZ));
	for (i=0, j=0; j<end_len; i+=4, j++){
		BYTEZ[j] = (localize[i+2] % 32 + 9) % 25 * 16 + (localize[i+3] %32 + 9) % 25;
	}
	BYTEZ[end_len] = '\0';
	return BYTEZ;
}


main(int argc, char **argv){
	//not totally my idea, I just added pass-shellcode-by-cli-args ability 
	//original:  http://shell-storm.org/shellcode/files/shellcode-841.php
	//gcc -m32 -fno-stack-protector -z execstack executor2.c -o executor2.elf

	if (argc < 2){ printf("[!] USAGE:  %s  [shellcode] \n", argv[0]); exit(1); }
	unsigned char *convarg = sc_via_cli_arg(argv);
	strcpy(shellcode, convarg);
	printf("%s\n%s\n%d bytes\n", argv[1], shellcode, strlen(shellcode));

	__asm__ ("movl $0xffffffff, %eax\n\t"
		 "movl %eax, %ebx\n\t"
		 "movl %eax, %ecx\n\t"
		 "movl %eax, %edx\n\t"
		 "movl %eax, %esi\n\t"
		 "movl %eax, %edi\n\t"
		 "movl %eax, %ebp\n\t"

		 // Calling the shellcode
		 "call shellcode");
}

