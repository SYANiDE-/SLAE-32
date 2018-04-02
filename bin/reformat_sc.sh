#!/bin/bash
# One-liner's multi-line shellcode, painlessly, heredoc-style
# Written by Chase Hatch
# Very similar to the following, but with bytecount:
# cat <<'EOF' | tr -d '\n' | sed -e 's/EOF//g' -e 's/["; ]//g' -e "s/[']//g" -e 's/.*/\#\ \"&\"/' && echo -e "\n"

temp=''
declare -a the_array
declare -a xfer
bytecount=0
took_pipe=0
shellcode=""
preamble="\\x"
helptext="""\
Reformats multi-line shellcode, painlessly, heredoc-style or piped inputs.
[!] USAGE: $0 [-o|-c|-n|-h|--help]

Opts:
	-o	Output shellcode-only
	-c	PASTED [non-piped] input is C lang format
	-n	PASTED [non-piped] input is ndisasm format
	-h	Help
	--help	Help
"""
sc_only=0
c_format=0
ndisasm_format=0


while [[ $# -gt 0 ]];
do
	opt="$1";
	shift;
	case "$opt" in
		'-o') sc_only=1;;
		'-c') c_format=1;;
		'-n') ndisasm_format=1;;
		'-h'|'--help') echo "$helptext"; exit 1;;
esac
done


if [[ -p /dev/stdin ]]; then
	if [[ $sc_only -eq 0 ]]; then
        	echo "[!] Receiving pipe."
	fi
        while IFS= read line
        do
                if [[ $(echo $line |grep -E "\\x") ]]; then
                        the_array[j]="$line"
                        let j=$(( $j + 1 ))
                fi
        done
	let took_pipe=$(( $took_pipe + 1))
else
	if [[ $# -ge 1 ]]; then echo -e "$helptxt"; exit 1; fi
	if [[ $sc_only -eq 0 ]]; then
		echo -e "[!] Enter quoted, multi-line shellcode (sans variable, '=', etc)."
		echo -e "[!] Heredoc-stye. Stop input with line having only 'EOF', no quotes:"
	fi
	while [[ "$temp" != "EOF" ]];
	do
		read -r temp
		the_array+=("$temp")
	done
	
	# the below will account for PASTED bytecode in C-style markup #
	if [[ $c_format -eq 1 ]]; then
		multiline_comment_opened=0
		the_array=("${the_array[@]/\/\*[^\*\/]*\*\// }")
		for item in "${the_array[@]}"; do
			item=($(echo $item |\
				 sed -re "s/[ ]+\/\///g" \
				-e "s/^\/\/.*//g"))
			if [[ "$item" =~ "/*" ]]; then multiline_comment_opened=1; fi
			if [[ "$item" =~ "*/" ]]; then multiline_comment_opened=0; fi
			if [[ "$item" =~ '"' ]] && [[ "$multiline_comment_opened" -eq 0 ]]; then
				xfer+=($(echo "$item" |\
					cut -d '"' -f 2 |\
					cut -d '"' -f 1))
			fi
		done
		shellcode="$(echo ${xfer[@]} |\
			 tr -d '\n' |\
			sed -e 's/\ //g')"
	fi
	# the above will account for PASTED bytecode in C-style markup #

	# the below will account for PASTED bytecode in ndisasm markup #
	if [[ $ndisasm_format -eq 1 ]]; then
		for item in "${the_array[@]}"; do
			if ! [[ -z $(echo $item |grep -E "[0-9a-fA-F]{8}") ]]; then
				xfer+=($(echo "$item" |\
					sed -re 's/[ ]{2}/^/' |\
					cut -d '^' -f 2 |\
					sed -re 's/[ ]+.*$//g'))
			fi
		done
		sc="$(echo ${xfer[@]} |tr -d '\n' |sed -re 's/[ ]+//g')"
		sc_len="${#sc}"
		if [[ $sc_only -eq 0 ]]; then
			echo "Total array length: ${#xfer[@]}"
			echo "SC_LEN = $sc_len"
			echo "$sc"
		fi
		i=0
		while [[ $i -lt $sc_len ]]; do
			shellcode="$shellcode$preamble${sc:0:2}"
			sc="${sc:2}"
			let i=(i+2)
		done
	fi
	# the above will account for PASTED bytecode in ndisasm markup #

fi

if [[ $c_format -eq 0 ]] && [[ $ndisasm_format -eq 0 ]]; then
	shellcode=$(echo "${the_array[@]}" | tr -d '\n' |\
		sed -e 's/EOF//g' \
		-e 's/\bunsigned\b//g' \
		-e 's/\bchar\b//g' \
		-e 's/\bbuf\b//g' \
		-e 's/\/\*.*\*\///g' \
		-e 's/\[\]//g' \
		-e 's/["; =*]//g' \
		-e "s/[']//g")
fi

if [[ $took_pipe -eq 1 ]]; then
	tmp="$(echo $shellcode |sed 's/x/\\x/g')"
	shellcode=$tmp
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

