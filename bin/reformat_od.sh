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
helptxt="Reformats objdump opcodes output, painlessly, heredoc-style\n[!] USAGE: $0\n"
shellcode=""

if [[ -p /dev/stdin ]]; then
	echo "[!] Receiving pipe."
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
	shellcode="$tmp"
fi

bytecount=$(( ${#shellcode} / 4 ))

echo -e "\n###"
echo -ne "#  "
printf "\"%s\"" $shellcode
echo -e "  # $bytecount bytes"
echo -e "###"


