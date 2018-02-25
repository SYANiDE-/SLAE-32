#!/usr/bin/env python2
import sys, os, argparse, random, string
# Multiple encoder formats supported!

class encoder():
	def __init__(s):
		s.args = s.getargs()
		s.xor = s.args.xor
		s.NOT = s.args.NOT
		s.encbyte = s.Argv_Bytestr(s.args.encbyte) if s.args.encbyte else None
		s.possible = s.args.possible
		s.param = ''.join(filter(None, [s.xor, s.NOT]))
		s.shellcode = s.Argv_Bytestr(s.param)
		s.s_len = len(bytearray(s.shellcode))
		s.outfile = s.args.outfile
		if s.possible or (s.xor and not s.encbyte):
			s.possible_encoder_bytes(s.shellcode)
			sys.exit()
				

	def getargs(s):
		ap = argparse.ArgumentParser(
			description="Multi-encoder for argv-supplied shellcode bytestrings")
		ap.add_argument("-n", '--NOT', type=str, default=None, 
			help="NOT-encode bytestring")	
		ap.add_argument("-x", '--xor', type=str, default=None, 
			help="XOR-encode bytestring")	
		ap.add_argument("-eb", '--encbyte', type=str, default=None, 
			help="XOR-encode encoder byte")	
		ap.add_argument("-p", '--possible', action="store_true", default=None, 
			help="Display list of possible XOR encoder bytes based on used characters")
		ap.add_argument("-o", '--outfile', type=str, default=None, 
			help="Write nasm decoder stub script based on chosen encoding method, to OUTFILE")
		args, l = ap.parse_known_args()
		if all(value is None for value in vars(args).values()):
			ap.print_help()
			sys.exit()
		else:
			return args
	

	def Argv_Bytestr(s, param):
		this=param.replace("\\x", "").replace("0x", "").replace(",","").replace(" ","")
		bytes = []
		for i in range(0, len(this), 2):
			bytes.append(chr(int(this[i:i+2],16)))
		return ''.join(bytes)


	def possible_encoder_bytes(s, param):
		used_bytes = ["%02x" % b for b in bytearray(param)]
		all_bytes = ["%02x" % x for x in range(1,256)]
		potential_bytes = [x for x in all_bytes if x not in used_bytes]
		common_bad_bytes = ['00', '0a', '0d']
		if "00" in used_bytes:
			print("\n[!] [!] [!] NULL BYTE detected in input! [!] [!] [!]\n")
		potential_byte_len = len(potential_bytes)
		used_bytes = sorted(set(used_bytes))
		poten_used_bad = [x for x in used_bytes if x in common_bad_bytes]
		print("[#] Used bytes:\n%s" % ",".join(used_bytes))
		if len(poten_used_bad) > 0:
			print("\n[!] WARN: Possible bad bytes in input!\n%s\n" 
				% ','.join(poten_used_bad))
		print("[#] Potential encoder bytes:\n%s" % ",".join(potential_bytes))
		print("[#] %d possible bytes / (\\x01 - \\xff)" % potential_byte_len)


	def xor_encode(s, param, a):
		s.c_style, s.z_style = "", ""	
		for b in bytearray(param):
			c = b ^ int(a.encode('hex'), 16)
			s.c_style += "\\x%02x" % c
			s.z_style += "0x%02x," % c
		if "00" in s.c_style or "00" in s.z_style:
			print("\n[!] [!] [!] NULL BYTE detected in output! [!] [!] [!]\n")
		s.z_style = s.z_style[:-1]


	def not_encode(s, param):
		s.c_style, s.z_style = "", ""	
		for b in bytearray(param):
			c =  ~b & 0xff
			s.c_style += "\\x%02x" % c
			s.z_style += "0x%02x," % c
		if "00" in s.c_style or "00" in s.z_style:
			print("\n[!] [!] [!] NULL BYTE detected in output! [!] [!] [!]\n")
		s.z_style = s.z_style[:-1]


	def write_decode_stub_nasm(s, enc_method):
		rl = []
		rl = [ s.rand_label() for x in range(0, 4) ]	
		output = """\
section .text
global _start
_start:
	jmp short %s
%s:
	pop esi
	xor ecx, ecx
	mov cl, %d
%s:
	%s
	inc esi
	loop %s
	jmp short %s
%s:
	call %s
	%s: 		db	%s
""" % (rl[0], rl[1], s.s_len, rl[2], enc_method, rl[2], rl[3],rl[0], rl[1], rl[3], s.z_style)
		FILE = s.outfile
		if not ".nasm" in FILE:
			FILE += ".nasm"
		with open(FILE, 'w') as F:
			for line in output:
				F.write(line)
		F.close()
		print("[!] Writing to outfile %s:\n%s" % (s.outfile, output))
		
			
	def rand_label(s):
		return "".join(random.choice(string.ascii_letters) for x in range(random.randrange(6,24))) 
		
		


def main():
	E = encoder()
	if E.xor and E.encbyte:
		E.xor_encode(E.shellcode, E.encbyte)
	if E.NOT:
		E.not_encode(E.shellcode)
	try:
		print("[#] C-style:\n\"%s\"" % E.c_style)
		print("[#] Zero-style:\n%s" % E.z_style)	
		print("[#] shellcode strlen %d bytes (0x%x)" % (E.s_len, E.s_len))
	except Exception, X:
		print(str(X))
	if E.outfile:
		if E.xor:
			method = "xor byte [esi], 0x%02x" % int(E.encbyte.encode('hex'), 16)
			E.write_decode_stub_nasm(method)
		if E.NOT:
			method = "not byte [esi]"
			E.write_decode_stub_nasm(method)
		

if __name__=="__main__":
	main()

