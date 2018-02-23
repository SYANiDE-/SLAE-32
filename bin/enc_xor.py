#!/usr/bin/env python2
import sys, os


def check_args():
	argc = len(sys.argv)
	if argc < 3:
		print("XOR encodes hex bytestring by hex encoder byte")
		print("[!] USAGE: %s [hex_str] [encoder_byte]")
		sys.exit()


def Argv_Bytestr(param):
	this=param.replace("\\x", "").replace("0x", "").replace(",","").replace(" ","")
	bytes = []
	for i in range(0, len(this), 2):
		bytes.append(chr(int(this[i:i+2],16)))
	return ''.join(bytes)


def xor_encode(param, a):
	# (a XOR b) = c
	# (a XOR c) = b
	# (b XOR c) = a
	c_style, z_style = "", ""
	for b in bytearray(param):
		c = b ^ int(a.encode('hex'), 16)
		c_style += "\\x%02x" % c
		z_style += "0x%02x," % c
	return c_style, z_style[:-1]

		
def main():
	check_args()
	shellcode = Argv_Bytestr(sys.argv[1])
	s_len = len(bytearray(shellcode))
	encoder_byte = Argv_Bytestr(sys.argv[2])
	c, z = xor_encode(shellcode, encoder_byte)
	print("[#] C-style: [#]\n\"%s\"" % c)
	print("[#] Zero-style: [#]\n%s" % z)
	print("[#] len %d bytes (0x%x) [#]" % (s_len, s_len))


if __name__=="__main__":
	main()
