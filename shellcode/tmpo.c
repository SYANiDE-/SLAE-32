#include <stdio.h>
#include <stdlib.h>
#include <string.h>
unsigned char* sc_via_cli_arg(char **argv);

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


int main(int argc, char **argv){
	unsigned char *convarg = sc_via_cli_arg(argv);
	unsigned char buf[strlen(convarg)];
	strcpy(buf, convarg);
	printf("%s\n", buf);
}
