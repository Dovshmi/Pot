#!/bin/bash
#installation script for pot -> creating the pot directory and pothocks.txt file
VAL=$HOME/.config/rofi/pot/pothooks.txt
VALPATH=$HOME/.config/rofi/pot
CHECK=$(test -f "$VAL" && echo "true" || echo "false")
if [[ "$CHECK" == "false" ]]; then
	echo "starting installations"
	mkdir $VALPATH
	echo "$VALPATH" >pothooks.txt
fi
