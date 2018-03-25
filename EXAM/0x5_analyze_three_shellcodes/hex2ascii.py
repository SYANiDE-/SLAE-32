#!/usr/bin/env python2
# Author: Chase Hatch
import sys, os

data=[]
NARGS=len(sys.argv)


def help():
	print("Converts hex to ascii, via heredoc-style input")
	print("[!] USAGE: %s [mode]" % sys.argv[0])
	print("Modes:")
	print("  -l	keeps line breaks")
	print("  -s	strip line breaks")
	sys.exit()


def grab_input():
	data=[]
	i=None;
	print("Simple hex-to-ascii printer.")
	print("[!!!] Heredoc input... EOF on line by itself to stop input.")
	while not i == "EOF":
		i = raw_input("")
		if not i == "EOF":
			data.append(str(i))
	return data


def converter(data):
	print("\n[#] Xlates to:")
	for item in data:
		item = item.replace("\\x","").replace("0x","").replace(",","").replace(" ","").replace('"','')
		i=0
		j=2
		for d in range(0,len(item)/2):
			#print(chr(int(item[i:j], 16)))
			print("\b%s" % chr(int(item[i:j],16))),
			i+=2
			j+=2
		print("")


def main():
	if NARGS == 1:
		help()
	elif NARGS == 2:
		if sys.argv[1] == '-s':
			data = grab_input()
			tmp = str(''.join(data))
			data = []
			data.append(tmp)
		if sys.argv[1] == '-l':
			data = grab_input()
	else:
		help()
	converter(data)	


if __name__=="__main__":
	main()
