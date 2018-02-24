#!/usr/bin/env python2
import sys, os

argc = len(sys.argv)

def check_args():
	if argc < 2:
		print("XOR encodes hex bytestring by hex encoder byte")
		print("  [!] USAGE: %s [hex_str] [encoder_byte]")
		print("  [?] omit [encoder_byte] to see list of potentials")
		sys.exit()


def Argv_Bytestr(param):
	this=param.replace("\\x", "").replace("0x", "").replace(",","").replace(" ","")
	bytes = []
	for i in range(0, len(this), 2):
		bytes.append(chr(int(this[i:i+2],16)))
	return ''.join(bytes)


def possible_encoder_bytes(param):
	all_bytes = ["%02x" % x for x in range(1,256)]
	for b in bytearray(param):
		if ("%02x" % b) in all_bytes:
			all_bytes.remove( ("%02x" % b) )
		if "00" in ("%02x" % b):
			print("\n[!] [!] [!] NULL BYTE detected in input! [!] [!] [!]\n")
	all_byte_len = len(all_bytes)
	if argc == 2:
		print("[#] Potential encoder bytes: [#]\n%s" % all_bytes)
		print("[#] %d possible bytes / (\\x01 - \\xff) [#]" % all_byte_len)


def xor_encode(param, a):
	# (a XOR b) = c
	# (a XOR c) = b
	# (b XOR c) = a
	c_style, z_style = "", ""	
	for b in bytearray(param):
		c = b ^ int(a.encode('hex'), 16)
		c_style += "\\x%02x" % c
		z_style += "0x%02x," % c
	if "00" in c_style or "00" in z_style:
		print("\n[!] [!] [!] NULL BYTE detected in output! [!] [!] [!]\n")
	return c_style, z_style[:-1]


def main():
	check_args()
	shellcode = Argv_Bytestr(sys.argv[1])
	s_len = len(bytearray(shellcode))
	if argc > 2:
		encoder_byte = Argv_Bytestr(sys.argv[2])
		c, z = xor_encode(shellcode, encoder_byte)
		print("[#] C-style: [#]\n\"%s\"" % c)
		print("[#] Zero-style: [#]\n%s" % z)
	else:
		possible_encoder_bytes(shellcode)
	print("[#] shellcode strlen %d bytes (0x%x) [#]" % (s_len, s_len))


if __name__=="__main__":
	main()

