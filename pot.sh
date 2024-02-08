#!/bin/bash

VAL=$HOME/.config/rofi/pot/pothoocks.txt
CHECK=$(test -f "$VAL" && echo "true" || echo "false")
if [[ "$CHECK" == "false" ]]; then
	dunstify "Cannot find pothooks.txt needs install.sh " -i danger -t 6000
	exit
fi
VALSORTED=$(sort $VAL | uniq)
echo "$VALSORTED" | tr ' ' '\n' >$VAL

foo=$(
	cat $VAL | rofi -dmenu -mesg "Normal Mode : [ D/[-] -> Delete ] | [ A/[+] -> Append ] | [ Enter -> Choose ] | [ ? -> Help ]" -theme "$HOME/.config/rofi/launchers/type-1/style-8.rasi"
)

case $foo in
"d" | "delete" | "Delete" | "D" | "-")
	dunstify "Delete Mode " -i danger -t 6000
	foo=$(cat $VAL | rofi -dmenu -mesg "Delete Mode : [ Enter - Delete ]" -theme "$HOME/.config/rofi/launchers/type-1/style-8.rasi")
	sed -i "\|^${foo}$|d" "$VAL"
	exit
	;;
"a" | "add" | "Add" | "A" | "append" | "Append" | "+")
	dunstify "Append Mode " -i danger -t 6000
	foo=$(rofi -dmenu -mesg "Append Mode : [ Enter - Append ]" -theme "$HOME/.config/rofi/launchers/type-1/style-8.rasi")
	if [ -n "$foo" ]; then
		echo "$foo" >>$VAL
	fi
	;;
"?")
	echo -e "Normal Mode -> Main hooked paths choosing menu\nDelete Mode -> Delete from hooked paths\nAppend Mode -> Append to hooked paths" |
		rofi -dmenu -mesg "Help Mode : [Enter - Choose]" -e - -theme "$HOME/.config/rofi/launchers/type-1/style-8.rasi"
	;;
esac

if grep --fixed-string -x "$foo" "$VAL"; then
	echo "$foo" | xclip -rmlastnl -selection clipboard
	dunstify "Clip Loaded" -i notification -t 6000
fi
