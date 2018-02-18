; execve_fixed.nasm
; Author:  Chase Hatch

global _start
section .bss
	cmd:	resb	 18	; will hold "/bin/bashABBBBCCCC"

section .data
	cmd_name: 	db	"/bin/bash"

section .text
_start:
	;; move bytes pointed-to in "cmd_name" into "cmd" string
	mov cl, 0x9		; "/bin/bash" len 9
	lea esi, [cmd_name]	; source string
	lea edi, [cmd]		; dest string
	cld			; clear direction flag
	rep movsb		; move sStr -> dStr byte by byte for count ecx
	xor eax, eax
	mov esi, cmd		; mov into eax, pointer-to-string cmd
	mov byte [esi+9], al	; @addr esi+9, zero-terminate (/bin/bash\0)
	mov dword [esi+10], eax	; @addr address esi+10, mov dword 0x0 (eax)
	mov dword [esi+14], eax	; @addr address esi+14, mov dword 0x0 (eax)

	; cmd_str now = "/bin/bash\0 0x00000000 0x00000000"
	
	; execve call  execve("/bin/bash", 0, 0);
	; execve call
	mov al, 0xb		; syscall 11 execve
	lea ebx, [esi]		; "/bin/bash\0"
	lea ecx, [esi+10]	; 0x00000000
	lea edx, [esi+14]	; 0x00000000
	int 0x80 


