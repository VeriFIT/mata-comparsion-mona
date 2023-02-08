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

