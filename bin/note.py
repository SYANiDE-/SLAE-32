#!/usr/bin/env python2
import datetime

data = []
i=None;

print("Notes... end input with EOF")
print("[%s]:" % (str(datetime.datetime.now())))
while not i == "EOF":
	i = raw_input("")
	if not i == "EOF":
		data.append(str(i))


with open("notes.txt", 'a') as F:
	F.write("\n[%s]:\n" % (str(datetime.datetime.now())))
	for line in data:
		F.write("%s\n" % (line))
