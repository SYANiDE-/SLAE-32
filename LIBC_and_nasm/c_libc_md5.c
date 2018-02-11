#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <openssl/md5.h>

int main(){
	unsigned char result[MD5_DIGEST_LENGTH];
	unsigned char *c = "This is a test of the emergency broadcast system"; 
	unsigned char *FmtStr1 = "%s";
	unsigned char *FmtStr2 = "%02x";
	unsigned char *FmtStr3 = "\n";
	int i = 0;
	printf(FmtStr1, c);
	printf(FmtStr1, FmtStr3);
	MD5(c, strlen(c), result);
	while(i != MD5_DIGEST_LENGTH){
		printf(FmtStr2, result[i]);
		i++;
	}
	printf(FmtStr1, FmtStr3);
	exit(0);
}

// gcc -g c_libc_md5.c -o c_libc_md5.elf -lssl -lcrypto
// output should be: 
// This is a test of the emergency broadcast system
// 2c2ac543af2c4975e98bd90ae7279a76

