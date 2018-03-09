#!/usr/bin/env python2
import os, sys, argparse, binascii


def getargs():
	ap = argparse.ArgumentParser(description="Reverse strings in various formats, ready for push to stack")
	ap.add_argument("-i", "--ipp", type=str, default=None, help='String is IP:PORT')
	ap.add_argument("-a", "--ascii", type=str, default=None, help='ASCII input string')
	ap.add_argument("-x", "--hex", type=str, default=None, help='HEX byte string (\x79)')
	ap.add_argument("-n", "--nopsled", action='store_true', default=None, help='NOPSLED any short of modulo 4 bytes')
	ap.add_argument("-X", "--x64", action='store_true', default=None, help='x64-bit register sizes')
	ap.add_argument("-m", "--mov", action='store_true', default=None, help='mov templated instructions instead of push')
	ap.add_argument("-b", "--blank", action='store_true', default=None, help='suppress instructions and just print in dwords')
	args, l = ap.parse_known_args()
	if args.ascii == None and args.hex == None and args.ipp == None:
		ap.print_help()
		sys.exit()
	else:
		return args


def hexdice(a):
	t = a.replace(r'\x', '')
	a=""
	b=len(t)
	c=0
	while c < b:
		a += t[-2:]
		t = t[:-2]
		c += 2
	return a
		

def ctrl_chars(a):
	a=a.replace('6e5c', '0a') # \n rev
	a=a.replace('745c', '09') # \t rev
	a=a.replace('765c', '0b') # \v rev
	a=a.replace('725c', '0d') # \r rev
	a=a.replace('625c', '08') # \b rev
	return a


def ip_port(a):
	tmp = []
	if len(a) >= 6:
		ip = ''.join(a).split(":")[0]
		tmp = ''.join(ip).split(".")
		port = (a).split(":")[1]
		# tmp.insert(0, port)
		tmp.append(port)
	else:
		tmp.append(a)
	tmp = ["%02x" % int(x) for x in tmp]
	tmp = tmp[::-1]
	for x in range(0, len(tmp)):
		temp = tmp[x]
		if not len(temp) % 2 == 0:
			temp = "0" + temp
			tmp[x] = temp
			tmp[x] = temp[2:] + temp[0:2] 
	bytes_len = len(tmp)
	if bytes_len == 5 or bytes_len == 1:
		tmp[0] = str(tmp[0][2]) + str(tmp[0][3]) + str(tmp[0][0]) + str(tmp[0][1]) # reverse port bytes!
	print(tmp)
	print("[!] Lines will probably be displayed in the opposite order than the order\nthey need to be pushed onto the stack! [!]")
	print("[!] The PUSH instruction for the port probably needs to be a PUSH WORD !")
	return(''.join(tmp))


def ip_port_prn(args, i):
	if not args.ipp == None:
		ip_prn = len(args.ipp)
		if ip_prn > 0:
			if ip_prn > 6 and i == 0:
				print("\t\t; PORT: %s" % args.ipp.split(":")[1]),
			if ip_prn > 6 and i != 0:
				print("\t; IP: %s" % args.ipp.split(":")[0]),
			if ip_prn < 6:
				print("\t\t; PORT: %s" % args.ipp),

	
def main():
	# this = ''
	args = getargs()
	ITER=0
	ITER_SZ=8 if args.x64 else 4
	REG_LEN = 16 if args.x64 else 8
	if args.ipp != None:
		this = ip_port(args.ipp)	
	if args.ascii != None:
		this = args.ascii[::-1].encode('hex')
	if args.hex != None:
		this = hexdice(args.hex)
	this = ctrl_chars(this)
	that = len(this)/2
	i = 0
	j = len(this)
	l = 0
	slack = ((j/2) % (REG_LEN / 2))
	if slack > 0:
		ITER = ((((j/2) + slack) / (REG_LEN / 2)) * ITER_SZ) - ITER_SZ
	else:
		ITER = (((j/2) / (REG_LEN / 2)) * ITER_SZ) - ITER_SZ 
	if slack == 1:
		ITER+=ITER_SZ
	SZ = REG_LEN if slack == 0 else slack*2
	if not args.x64:
		mov_inst_word = ['dword', 'byte', 'word', 'BADSIZE']
		push_inst_word = ['dword 0x', 'byte 0x', 'word 0x', 'BADSIZE 0x']
	else:
		mov_inst_word = ['qword', 'byte', 'word', 'BADSIZE', 'dword', 'BADSIZE', 'BADSIZE', 'BADSIZE']
		push_inst_word = ['qword 0x', 'byte 0x', 'word 0x', 'BADSIZE 0x', 'dword 0x', 'BADSIZE 0x', 'BADSIZE 0x', 'BADSIZE 0x']
	while i < j:
		if not args.nopsled:
			mov_inst = mov_inst_word[slack]
			push_inst = push_inst_word[slack]
		if not (i == 0):
			print("")
		if not args.blank:
			if args.mov:
				print("mov %s [esp+%d], 0x" % (mov_inst, ITER)),
			else:
				print("push %s" % push_inst),
		if slack != 0:
			if args.nopsled == True:
				print("\b%s" % ("90" * ((REG_LEN/2) - slack))),
		print("\b%s" % this[:SZ]),
		l = 0
		if slack != 0 and args.nopsled == True and args.mov == None:
			print("\t"),
		print("\t;  "),
		while l < SZ  and l < j:
		 	print("\b%c" % int(this[l:l+2], 16)),
		 	l+=2
		this = this[SZ:]
		ip_port_prn(args, i)
		i+=SZ
		if slack !=0:
			j = len(this)
			slack = 0
			SZ = REG_LEN
		ITER-=ITER_SZ
	print("\n# %s bytes (0x%x)" % (that, that))


if __name__=="__main__":
	main()

