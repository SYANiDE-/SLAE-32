rule WRITE_sycall
{
	strings:
		$a_WRITE_push0x4popEAXsyscall = {6a 04 58 [0-100] cd 80}
		$a_WRITE_movAL0x4syscall = {b0 04 [0-100] cd 80}
		$a_WRITE_movAX0x4syscall = {66 b8 04 [0-100] cd 80}
		$a_WRITE_movEAX0x4syscall = {b8 04 [0-100] cd 80}
	condition:
		1 of them
}

rule OPEN_syscall
{
	strings:
		$a_OPEN_push0x5popEAXsyscall = {6a 05 58 [0-100] cd 80 }
		$a_OPEN_movAL0x5syscall = {b0 05 [0-100] cd 80}
		$a_OPEN_movAX0x5syscall = {66 b8 05 [0-100] cd 80}
		$a_OPEN_movEAX0x5syscall = {b8 05 [0-100] cd 80}
	condition:
		1 of them
}	

rule READ_syscall
{
	strings:
		$a_READ_push0x3popEAXsyscall = {6a 03 58 [0-100] cd 80 }
		$a_READ_movAL0x3syscall = {b0 03 [0-100] cd 80}
		$a_READ_movAX0x3syscall = {66 b8 03 [0-100] cd 80}
		$a_READ_movEAX0x3syscall = {b8 03 [0-100] cd 80}
	condition:
		1 of them

}

rule GET_EIP
{
	strings:
		$a_GET_EIP_fcmovb = {da (c0 | c1 | c2 | c3 | c4 | c5 | c6 |c7)}
		$a_GET_EIP_fcmove = {da (c8 | c9 | ca | cb | cc | cd | ce |cf)}
		$a_GET_EIP_fcmovbe = {da (d0 | d1 | d2 | d3 | d4 | d5 | d6 |d7)}
		$a_GET_EIP_fcmovu = {da (d8 | d9 | da | db | dc | dd | de |df)}
		$a_GET_EIP_fcmovnb = {db (c0 | c1 | c2 | c3 | c4 | c5 | c6 |c7)}
		$a_GET_EIP_fcmovne = {db (c8 | c9 | ca | cb | cc | cd | ce |cf)}
		$a_GET_EIP_fcmovnbe = {db (d0 | d1 | d2 | d3 | d4 | d5 | d6 |d7)}
		$a_GET_EIP_fcmovnu = {db (d8 | d9 | da | db | dc | dd | de |df)}	

		$b_GET_EIP_fnstenvESP = {d9 34 24}
		$b_GET_EIP_fstenvESP = {9b d9 34 24}
		$b_GET_EIP_fnstenvESP_0xc = {d9 74 24 F4}
		$b_GET_EIP_fstenvESP_0xc =  {9b d9 74 24 f4}
			
	condition:
		1 of ($a*) and 1 of ($b*)
}	
