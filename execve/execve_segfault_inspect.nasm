; execve_segfault_inspect.nasm
; Author:  Chase Hatch
;; Inspection of segfault in execve.elf
;;, when passed in to executor2


section .text
global _start
_start:
	jmp short EXECVE
alpha:
	pop esi
	xor eax, eax
	mov byte [esi+9], al
	mov dword [esi+10], eax
	mov dword [esi+14], eax
	mov al, 0xb		;syscall 11 execve
	lea ebx, [esi]
	lea ecx, [esi+10]
	lea edx, [esi+14]
	int 0x80

EXECVE:
	call alpha
	execve_msg		db	"/bin/bashABBBBCCCC"


;;;  When loaded in GDB, execve.elf segfaults at the instruction pinted to in output.
;;;  The very next stepi is the segfault and crash.  Happens to be the first
;;;  instruction to modify the string on the stack.
;;;  The only thing that changes when the instruction is executed is the
;;;  RF flag (Resume) is set.  Next stepi is exit due to SIGSEV segfault.
;;;  I'm assuming this is attributed to trying to modify an immutable string?
;;;  
;;;  
;;;  ./View
;;;  define hook-stop
;;;  print/x $eax
;;;  print/x $ebx
;;;  print/x $ecx
;;;  print/x $edx
;;;  print/x $esi
;;;  x/s $esi
;;;  print $eflags
;;;  disassemble $eip,+10
;;;  x/8xw $esp
;;;  end
;;;  break *alpha+3
;;;  run
;;;  
;;;  
;;;  gdb -q execve.elf -x view
;;;  stepi  ; SIGSEV segfault and sets RF flag = 1
;;;  
;;;  $31 = 0x0
;;;  $32 = 0x0
;;;  $33 = 0x0
;;;  $34 = 0x0
;;;  $35 = 0x804807f
;;;  0x804807f <execve_msg>:	 "/bin/bashABBBBCCCC"
;;;  $36 = [ PF ZF IF RF ]
;;;  Dump of assembler code from 0x8048065 to 0x804806f:
;;;  => 0x08048065 <alpha+3>:	mov    BYTE PTR [esi+0x9],al
;;;     0x08048068 <alpha+6>:	mov    DWORD PTR [esi+0xa],eax
;;;     0x0804806b <alpha+9>:	mov    DWORD PTR [esi+0xe],eax
;;;     0x0804806e <alpha+12>:	mov    al,0xb
;;;  End of assembler dump.
;;;  0xbffff3e0:	0x00000001	0xbffff559	0x00000000	0xbffff581
;;;  0xbffff3f0:	0xbffff594	0xbffff5aa	0xbffff5ba	0xbffff5d0
;;;  
;;;  stepi ; from here, terminates program on segfault



