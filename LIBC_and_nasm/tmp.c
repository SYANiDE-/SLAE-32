#include <stdlib.h>
#include <stdio.h>
#include <openssl/md5.h>

int main(){
	printf("%d\n", MD5_DIGEST_LENGTH);
	exit(0);
}

// gcc -g tmp.o -o tmp.elf -lssl -lcrypto
// Outputs:
// 16
