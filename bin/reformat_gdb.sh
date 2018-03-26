#!/bin/bash
# reformats GDB x/xb output, painlessly, heredoc-style
# Written by Chase Hatch

temp=''
declare -a the_array
bytecount=0
preamble='\x'
i=0
j=0
tmp=""
shellcode=""
helptext="""\
Reformats GDB x/xb output, painlessly, heredoc-style.
[!] USAGE: $0 [-o|-h|--help]

Opts:
	-o	Output shellcode-only
	-h	Help
	--help	Help
"""
sc_only=0

while [[ $# -gt 0 ]];
do
	opt="$1";
	shift;
	case "$opt" in
		'-o') sc_only=1;;
		'-h'|'--help') echo "$helptext"; exit 1;;
esac
done


if [[ $# -ge 1 ]]; then echo -e "$helptxt"; exit 1; fi
if [[ $sc_only -ne 1 ]]; then 
	echo -e "[!] Enter multiline GDB output here."
	echo -e "[!] Heredoc-stye. Stop input with line having only 'EOF', no quotes:"
fi
while [[ "$temp" != "EOF" ]];
do
	read -r temp
	the_array+=("$temp")
done
sc=$(echo "${the_array[@]}" |\
	sed -re 's/0x[0-9a-f]{7}\ //g' \
	-e 's/\ //g' 		\
	-e 's/EOF//g' 		\
	-e 's/0x//g' 		\
	-e 's/</\n/g' |		\
	cut -d ':' -f 2 |	\
	tr -d '\t' |		\
	tr -d '\n')

if [[ $sc_only -ne 1 ]]; then 
	echo "$sc"
fi

sc_len="${#sc}"
while [[ $(echo $i) -lt $sc_len ]]
do
	tmp="$tmp$preamble${sc:0:2}"
	sc="${sc:2}"
	let i=(i+2)
done
cleaned=$(echo "$tmp" |sed 's/\\x\\x/\\x/g')
shellcode="$cleaned"

bytecount=$(( ${#shellcode} / 4 ))


if [[ $sc_only -eq 1 ]]; then
	printf "%s" $shellcode
else
	echo -e "\n###"
	echo -ne "#  \""
	printf "%s" $shellcode
	echo -e "\"  # $bytecount bytes"
	echo -e "###"
fi


