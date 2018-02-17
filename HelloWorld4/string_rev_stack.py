#!/usr/bin/env python2
import os, sys, argparse


def getargs():
	ap = argparse.ArgumentParser(description="Reverse strings in various formats, ready for push to stack")
	ap.add_argument("-a", "--ascii", type=str, default=None, help='ASCII input string')
	ap.add_argument("-x", "--hex", type=str, default=None, help='HEX byte string (\x79)')
	ap.add_argument("-n", "--nopsled", action='store_true', default=None, help='NOPSLED any short of modulo 4 bytes')
	ap.add_argument("-X", "--x64", action='store_true', default=None, help='x64-bit register sizes')
	args, l = ap.parse_known_args()
	if args.ascii == None and args.hex == None:
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
	

	
def main():
	# this = ''
	args = getargs()
	REG_LEN = 16 if args.x64 else 8
	if args.ascii != None:
		this = args.ascii[::-1].encode('hex')
	if args.hex != None:
		this = hexdice(args.hex)
	this = ctrl_chars(this)
	that = len(this)/2
	i = 0
	j = len(this)
	while i < j:
		if not (i == 0):
			print("")
		print("push 0x%s" % this[:REG_LEN]),
		if (j - i) < REG_LEN and args.nopsled == True:
			k = (REG_LEN - (j - i))/2 
			that += k
			print('\b%s' % ('90'*k)),
		this = this[REG_LEN:]
		i+=REG_LEN
	print("\n# %s bytes" % that)


if __name__=="__main__":
	main()

