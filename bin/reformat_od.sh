#!/bin/bash
# reformats objdump output, painlessly, heredoc-style
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
Reformats objdump opcodes output, painlessly, heredoc-style or piped inputs.
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

if [[ -p /dev/stdin ]]; then
	if [[ $sc_only -eq 0 ]]; then
		echo "[!] Receiving pipe."
	fi
	while IFS= read line
	do
		if [[ $(echo $line |grep -E "[0-9a-f]{7}:") ]]; then
			the_array[j]="$line"
			let j=$(( $j + 1 ))
		fi
	done
	for item in "${the_array[@]}"; do
		shellcode+=$(echo "$item" |\
			cut -d $'\t' -f 2 |\
			sed -re 's/[ ]{3}+.*//g' \
			-e 's/^.*/\\x&/g' \
			-e 's/\ /\\x/g')
	done
	tmp=$(echo "$shellcode" |sed 's/\\x\\x/\\x/g')
	shellcode=$tmp
else
	if [[ $# -ge 1 ]]; then echo -e "$helptxt"; exit 1; fi
	echo -e "[!] Enter multiline objdump opcode output (-d) here."
	echo -e "[!]  (objdump -M intel -d file.elf |cut -d \$'\\\\t' -f 2) "
	echo -e "[!] Heredoc-stye. Stop input with line having only 'EOF', no quotes:"
	while [[ "$temp" != "EOF" ]];
	do
		read -r temp
		the_array+=("$temp")
	done
	sc=$(echo "${the_array[@]}" | tr '\n' ' ' | sed -re 's/[ ]+//g' -e 's/EOF//g')
	sc_len="${#sc}"
	while [[ $(echo $i) -lt $sc_len ]]
	do
		tmp="$tmp$preamble${sc:0:2}"
		sc="${sc:2}"
		let i=(i+2)
	done
	cleaned=$(echo "$tmp" |sed 's/\\x\\x/\\x/g')
	shellcode="$cleaned"
fi

bytecount=$(( ${#shellcode} / 4 ))


if [[ $sc_only -eq 1 ]]; then
	printf "%s" $shellcode
else
	echo -e "\n###"
	echo -ne "#  "
	printf "\"%s\"" $shellcode
	echo -e "  # $bytecount bytes"
	echo -e "###"
fi


