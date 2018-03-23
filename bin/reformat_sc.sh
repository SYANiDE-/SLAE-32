#!/bin/bash
# One-liner's multi-line shellcode, painlessly, heredoc-style
# Written by Chase Hatch
# Very similar to the following, but with bytecount:
# cat <<'EOF' | tr -d '\n' | sed -e 's/EOF//g' -e 's/["; ]//g' -e "s/[']//g" -e 's/.*/\#\ \"&\"/' && echo -e "\n"

temp=''
declare -a the_array
bytecount=0
took_pipe=0
helptext="""\
Reformats multi-line shellcode, painlessly, heredoc-style or piped inputs.
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
fi


shellcode=$(echo "${the_array[@]}" |\
		tr -d '\n' |\
		sed -e 's/EOF//g' \
		-e 's/\bunsigned\b//g' \
		-e 's/\bchar\b//g' \
		-e 's/\bbuf\b//g' \
		-e 's/\[\]//g' \
		-e 's/["; =*]//g' \
		-e "s/[']//g")

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
