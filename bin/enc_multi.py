#!/usr/bin/env python2
import sys, os, argparse, random, string
# Multiple encoder formats supported!

class encoder():
	def __init__(s):
		s.args = s.getargs()
		s.nullbyte_in =""
		s.nullbyte_out =""
		s.xor = s.args.xor
		s.NOT = s.args.NOT
		s.insert = s.args.insert
		s.encbyte = s.Argv_Bytestr(s.args.encbyte) if s.args.encbyte else None
		s.possible = s.args.possible
		s.param = ''.join(filter(None, [s.xor, s.NOT, s.insert]))
		s.shellcode = s.Argv_Bytestr(s.param)
		s.s_len = len(bytearray(s.shellcode))
		s.outfile = s.args.outfile
		s.compiler = s.args.compiler
		s.common_bad_bytes = ['00', '0a', '0d']
		s.all_bytes = ["%02x" % x for x in range(1,256)]
		s.used_bytes = ["%02x" % b for b in bytearray(s.shellcode)]
		s.used_bytes = sorted(set(s.used_bytes))
		s.poten_used_bad = [x for x in s.used_bytes if x in s.common_bad_bytes]
		if "00" in s.used_bytes:
			s.nullbyte_in = "TRUE"
		if s.possible or (s.xor and not s.encbyte):
			s.possible_encoder_bytes()
			sys.exit()
				

	def getargs(s):
		ap = argparse.ArgumentParser(
			description="Multi-encoder for argv-supplied shellcode bytestrings")
		ap.add_argument("-n", '--NOT', type=str, default=None, 
			help="NOT-encode bytestring")	
		ap.add_argument("-i", '--insert', type=str, default=None, 
			help="INSERTION-encode bytestring")	
		ap.add_argument("-x", '--xor', type=str, default=None, 
			help="XOR-encode bytestring")	
		ap.add_argument("-eb", '--encbyte', type=str, default=None, 
			help="XOR-encode encoder byte")	
		ap.add_argument("-p", '--possible', action="store_true", default=None, 
			help="Display list of possible XOR encoder bytes based on used characters")
		ap.add_argument("-o", '--outfile', type=str, default=None, 
			help="Write nasm decoder stub script based on chosen encoding method, to OUTFILE")
		ap.add_argument("-c", '--compiler', action="store_true", default=None, 
			help="com(nasm)pile decoder stub script and objdump {.elf} | reformat_od.sh (REQUIRES -o)")
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


	def possible_encoder_bytes(s):
		potential_bytes = [x for x in s.all_bytes if x not in s.used_bytes]
		potential_byte_len = len(potential_bytes)
		print("[#] Potential encoder bytes:\n%s" % ",".join(potential_bytes))
		print("[#] %d possible bytes / (\\x01 - \\xff)" % potential_byte_len)


	def xor_encode(s, param, a):
		# exclusive OR operation
		s.c_style, s.z_style = "", ""	
		for b in bytearray(param):
			c = b ^ int(a.encode('hex'), 16)
			s.c_style += "\\x%02x" % c
			s.z_style += "0x%02x," % c
		if "00" in s.c_style or "00" in s.z_style:
			s.nullbyte_out = "TRUE"
		s.z_style = s.z_style[:-1]


	def not_encode(s, param):
		# encodes bytes as ones-complient AND operationi. (NOT)
		s.c_style, s.z_style = "", ""	
		for b in bytearray(param):
			c =  ~b & 0xff
			s.c_style += "\\x%02x" % c
			s.z_style += "0x%02x," % c
		if "00" in s.c_style or "00" in s.z_style:
			s.nullbyte_out = "TRUE"
		s.z_style = s.z_style[:-1]


	def insert_encode(s, param):
		# inserts random byte every-other of original shellcode
		s.c_style, s.z_style = "", ""	
		all_bytes = ["%02x" % x for x in range(1,256)]
		for b in bytearray(param):
			c = int(all_bytes[random.randint(0,254)], 16)
			s.c_style += "\\x%02x" % b
			s.c_style += "\\x%02x" % c
			s.z_style += "0x%02x," % b
			s.z_style += "0x%02x," % c
		if "00" in s.c_style or "00" in s.z_style:
			s.nullbyte_out = "TRUE"
		s.z_style = s.z_style[:-1]


	def write_decode_stub_nasm(s, dec_method, setup=""):
		rl = []
		rl = [ s.rand_label() for x in range(0, 4) ]	
		s.output = """\
section .text
global _start
_start:
	jmp short %s
%s:
	pop esi
	xor ecx, ecx
	mov cl, %d
	%s
%s:
	%s
	inc esi
	loop %s
	jmp short %s
%s:
	call %s
	%s: 		db	%s
""" % (rl[0], rl[1], s.s_len, setup, rl[2], dec_method, rl[2], rl[3],rl[0], rl[1], rl[3], s.z_style)
		FILE = s.outfile
		if not ".nasm" in FILE:
			FILE += ".nasm"
		with open(FILE, 'w') as F:
			for line in s.output:
				F.write(line)
		s.outfile = FILE
		F.close()
		
			
	def rand_label(s):
		return "".join(random.choice(string.ascii_letters) for x in range(random.randrange(6,24))) 


	def encode(s):
		if s.xor and s.encbyte:
			s.xor_encode(s.shellcode, s.encbyte)
		if s.NOT:
			s.not_encode(s.shellcode)
		if s.insert:
			s.insert_encode(s.shellcode)


	def writer(s):
		if s.xor and s.encbyte:
			method = "xor byte [esi], 0x%02x" % int(s.encbyte.encode('hex'), 16)
			s.write_decode_stub_nasm(method)
		if s.NOT:
			method = "not byte [esi]"
			s.write_decode_stub_nasm(method)
		if s.insert:
			start = "lea edi, [esi]\n\txor eax,eax\n\txor ebx,ebx\n\t"
			method = "mov bl, byte [edi + eax]\n\tmov byte [esi], bl\n\tadd al, 2"
			s.write_decode_stub_nasm(dec_method=method, setup=start)


	def printer(s):
		print("")
		print("[#] Used bytes:\n%s\n" % ",".join(s.used_bytes))
		print("[#] C-style encoded:\n\"%s\"\n" % s.c_style)
		print("[#] Zero-style encoded:\n%s\n" % s.z_style)	
		print("[#] shellcode strlen %d bytes (0x%x)" % (s.s_len, s.s_len))
		if s.insert:
			print("[#] encoded strlen %d bytes (0x%x)" % (s.s_len*2, s.s_len*2))
		if s.outfile:
			s.writer()
			print("[!] Wrote to outfile %s:\n%s" % (s.outfile, s.output))
		if s.nullbyte_in:
			print("\n[!] [!] [!] NULL BYTES.detected in input! [!] [!] [!]\n")
		if s.nullbyte_out:
			print("\n[!] [!] [!] NULL BYTES.detected in output! [!] [!] [!]\n")
		if len(s.poten_used_bad) > 0:
			print("\n[!] WARN: Possible bad bytes in input!\n%s\n" % ','.join(s.poten_used_bad))


	def nasmpile_dump(s):
		if s.outfile and s.compiler:
			try:
				print(os.system('nasmpile '  +s.outfile+  " -g -s"))
				print(os.system("objdump -M intel -d " 
					+str(s.outfile).replace(".nasm", ".elf")+  "| reformat_od.sh"))
			except Exception, X:
				print(str(X))

def main():
	E = encoder()	
	E.encode()
	E.printer()
	E.nasmpile_dump()
	

if __name__=="__main__":
	main()

