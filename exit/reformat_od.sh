#!/bin/bash
# reformats objdump output, painlessly, heredoc-style
# Written by Chase Hatch

temp=''
declare -a the_array
bytecount=0
preamble='\x'
i=0
tmp=""
helptxt="Reformats objdump opcodes output, painlessly, heredoc-style\n[!] USAGE: $0\n"
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
bytecount=$(( ${#shellcode} / 4 ))


echo -e "\n###"
echo -ne "#  "
printf "%s" $shellcode
echo -e "  # $bytecount bytes"
echo -e "###"

