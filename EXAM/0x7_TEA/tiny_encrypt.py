#!/usr/bin/env python2
import os, sys, hashlib, struct, binascii, getpass
from ctypes import c_uint32


def Argv_Bytestr(param):
	this=param.replace("\\x", "").replace("0x", "").replace(",","").replace(" ","")
	bytes = []
	for i in range(0, len(this), 2):
		bytes.append(chr(int(this[i:i+2],16)))
	return ''.join(bytes)


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


def encrypt(v, k):
	plainT = bytearray(v)
	cipherT = bytearray()
	key = []
	keys = []
	for x in range(0, len(k), 2):
		key.append(int(k[x:x+2], 16))
	for item in range(0, 16, 4):
		this = ''.join([ chr(x) for x in key[item:item+4] ])
		keys.append(c_uint32(struct.unpack("I", this)[0]).value)
	i = 0 
	for point in range(0, len(plainT), 8):
		summ = 0 
		delta = 0x9e3779b9
		v0 = c_uint32(struct.unpack("I", ''.join([ chr(x) for x in plainT[point:point+4]]))[0]).value
		v1 = c_uint32(struct.unpack("I", ''.join([ chr(x) for x in plainT[point+4:point+8]]))[0]).value
		for i in range(0,32):
			summ = c_uint32(summ + delta).value
			v0 = add(v0, XOR(shift_L(v1, keys[0]), add(v1, summ), shift_R(v1, keys[1])))
			v1 = add(v1, XOR(shift_L(v0, keys[2]), add(v0, summ), shift_R(v0, keys[3])))
		cipherT +=  struct.pack("I", v0)
		cipherT +=  struct.pack("I", v1)
	ciphertext = "\\x"
	ciphertext += '\\x'.join("%02x" % x for x in cipherT)
	return ciphertext


def main():
	NARGS = len(sys.argv)

	# hash encryption key
	hashl = hashlib.md5()
	if NARGS == 3:
		hashl.update(sys.argv[2])
	else:
		hashl.update(getpass.getpass())
	key=hashl.hexdigest()

	# get shellcode
	if NARGS >= 2:
		plaintext = Argv_Bytestr(sys.argv[1])
		
	else:
		plaintext = Argv_Bytestr(raw_input("[#] Give unencrypted shellcode:\n"))

	# pad-align with NOPs to 64-bit (8 byte) block size
	remain = 8 - (len(plaintext) % 8)
	plaintext += "\x90" * remain

	# encrypt shellcode
	print(encrypt(plaintext, key))


if __name__=="__main__":
	main()

