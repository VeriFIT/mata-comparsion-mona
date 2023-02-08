#!/bin/sh
#
# Translate VATA input into a MATA input
# VATA timbuk format has no initial states. 
# We expect, that there is a special symbol x:0 in Ops, which togather with the rule x -> q1 represent that q1 is an initial state.
#

ALPHABET_FILE="alpha.txt"
BIT_ALPHA_FILE="bit_alpha_map.txt"

touch $ALPHABET_FILE

echo "Creating alphabet into the $ALPHABET_FILE" and MATA bit mapping to "$BIT_ALPHA_FILE"

compute_log_upper () {
	res=`echo "(l($1)/l(2))+1" | bc -l |sed "s/\(.*\)\..*/\1/"`
	echo $res
}

add_to_result () {
	toadd=`echo $1 | sed 's/\(.*\):1$/\1/'`
	if grep "^$toadd\$" $ALPHABET_FILE > /dev/null; then
		true
	else
		echo "$toadd" >> $ALPHABET_FILE
	fi
}

for F in $@; do
	if grep '^Ops \([^:]*:1 \)*x:0 *$' "$F" >/dev/null;
	then
		LINE=`grep '^Ops \([^:]*:1 \)*x:0 *$' "$F" | sed 's/Ops \(.*\)x:0 *$/\1/'`
		for i in $LINE; do
			add_to_result $i
		done
	else
		echo "file $F not in expected format"
	fi
done

VARS=`wc -l < $ALPHABET_FILE`
BITS=`compute_log_upper $VARS`

no=0

create_bits () {
	b=1
	res="$1:("
	delimiter=""
	curr=$2
	while [ $3 -ge $b ]; do
		if [ $(($curr % 2)) -eq 1 ]; then x="!"; else x=""; fi 		
		res="${res}${delimiter}${x}a$b"
		b=$(($b + 1))
		curr=$(($curr / 2))
		delimiter=" & "
	done
	echo "${res})"
}

echo "" > "$BIT_ALPHA_FILE"
while read -r line; do 
	create_bits $line $no $BITS >>  "$BIT_ALPHA_FILE"
	no=$(($no + 1))
done < $ALPHABET_FILE
