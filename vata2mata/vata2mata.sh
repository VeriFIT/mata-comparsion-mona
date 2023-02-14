#!/bin/sh
#
#Traslate VATA Timbuk imput file into MATA bits 
#
#First use create_alphabet.sh to create alphabet mapping from Timbuk to bits

ALPHA_MAP=bit_alpha_map.txt

if [ ! -f "$ALPHA_MAP" ]; then
	echo "Expecting alphabet mapping file $ALPHA_MAP"
	echo "Use create_alphabet.sh to create alphabet mapping from Timbuk to bits"
	exit
else true; fi

if `grep "^Automaton .*" $1> /dev/null`; then true;
else
	echo "Broken Timbuk format in $1"
	exit
fi

echo "@NFA-bits"

init1=`grep "^x *->" $1 | sed "s/.* ->\(.*\)$/\1/"`
init=`echo $init1 | sed "s/\([^ ]\)  *\([^ ]\)/\1 | \2/g"`
echo "%Initial $init"

final=`grep "^Final State" $1 | sed "s/^Final States \(.*\)$/\1/"`
final=`echo $final | sed "s/\([^ ]\)  *\([^ ]\)/\1 | \2/g"`
#echo "%Final $final"

# compute final states in negative form
allstates=`grep "^States " $1 | sed "s/^States //"`

echo -n "%Final "
delimiter=""
for i in $allstates; do
	if echo $final | grep "^$i \| $i \| $i\$\|^$i\$" > /dev/null; then true; 
	else 
	echo -n "$delimiter!$i "
	delimiter="& "
	fi
done
echo


substitute_line () {
	while read a; do
		symbol=`echo $a | sed "s/^ *\([^ (][^ (]*\).*/\1/"`
		state2=`echo $a | sed "s/^.*-> *\([^ ][^ ]*\) */\1/"`
		state1=`echo $a | sed "s/^.*( *\([^ )][^ )]*\) *).*/\1/"`
		bit_symbol=`grep "^$symbol:" "$ALPHA_MAP" | sed "s/^.*://"`
		echo $state1 $bit_symbol $state2

	done
}

grep "(..*) *->" $1 | substitute_line
