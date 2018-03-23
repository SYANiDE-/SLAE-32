#!/usr/bin/env python2

data = []
i=None;

print("Notes... end input with EOF")
print("[!] Note [!]\n")
while not i == "EOF":
	i = raw_input("")
	if not i == "EOF":
		data.append(str(i))

print("\n[!] Note [!]")
