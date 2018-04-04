#!/usr/bin/env python2
import os, sys, argparse, binascii

NARGS=len(sys.argv)


def getargs():
	ap=argparse.ArgumentParser(description="Simple ascii-to-hex")
	ap.add_argument("-a", '--ascii', type=str, default=None, help="output in bytecode format")
	ap.add_argument("-b", '--bytecode', action='store_true', default=None, help="output in bytecode format")
	ap.add_argument('-r', '--reverse', action='store_true', default=None, help="reverse the input string")
	args, l = ap.parse_known_args()
	if NARGS < 2 or args.ascii == None:
		ap.print_help()
		sys.exit(1)
	else:
		return args


def gethex(inp):
	tmp = ""
	for item in inp:
		tmp = tmp + binascii.hexlify(item)
	return tmp


def byte_it(inp):
	a=""
	b=len(inp)
	c=0
	while c < b:
		a += "\\x%s" % inp[0:2]
		inp = inp[2:]
		c += 2
	return a	


def statistics(inp):
	length=len(inp)
	if inp.find(r'\x') != -1:
		length=length/4
	print("[#] length: %s bytes" % length)


def get_reverse(inp):
	return inp[::-1]


def main():
	args = getargs()
	hexxed = args.ascii
	mod = ""
	if args.reverse:
		hexxed = get_reverse(hexxed)
		mod = mod + "reversed "
	original = hexxed
	hexxed = gethex(hexxed)
	if args.bytecode:
		hexxed = byte_it(hexxed)
	statistics(hexxed)
	print("[#] Original %s: %s" % (mod, original))
	print("\"%s\"" % (hexxed))


if __name__=="__main__":
	main()
