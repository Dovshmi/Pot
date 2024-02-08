#!/bin/bash

HOOKS="$HOME/.config/rofi/pot/pothooks.txt"
CHECK=$(test -f "$HOOKS" && echo "true" || echo "false")
THEME="$HOME/.config/rofi/launchers/type-1/style-8.rasi"
MENU="rofi -dmenu"

if [[ "$CHECK" == "false" ]]; then
	dunstify "Cannot find pothooks.txt, needs install.sh " -i danger -t 6000
	exit
fi

HOOKSSORTED=$(sort "$HOOKS" | uniq)
echo "$HOOKSSORTED" | tr ' ' '\n' >"$HOOKS"

while true; do
	foo=$(
		cat "$HOOKS" | ${MENU} -mesg "Normal Mode : [ D/[-] -> Delete ] [ A/[+] -> Append ] [ Enter -> Choose ] [ ? -> Help ]" -theme "$THEME"
	)
	case $foo in
	"d" | "delete" | "Delete" | "D" | "-")
		dunstify "Delete Mode " -i danger -t 6000
		foo=$(cat "$HOOKS" | ${MENU} -mesg "Delete Mode : [ Enter - Delete ]" -theme "$THEME")
		sed -i "\|^${foo}$|d" "$HOOKS"
		;;
	"a" | "add" | "Add" | "A" | "append" | "Append" | "+")
		dunstify "Append Mode " -i danger -t 6000
		foo=$(${MENU} -mesg "Append Mode : [ Enter - Append ]" -theme "$THEME")
		if [ -n "$foo" ]; then
			echo "$foo" >>"$HOOKS"
		fi
		;;
	"?")
		echo -e "Normal Mode -> Main hooked paths choosing menu\nDelete Mode -> Delete from hooked paths\nAppend Mode -> Append to hooked paths" |
			${MENU} -mesg "Help Mode : [Enter - Choose]" -e - -theme "$THEME"
		;;
	"exit" | "q" | "quit" | ":q" | ":wq" | "")
		break # Exit the loop
		;;
	*)
		if grep --fixed-string -x "$foo" "$HOOKS"; then
			echo "$foo" | xclip -rmlastnl -selection clipboard
			dunstify "Clip Loaded" -i notification -t 6000
			break
		fi
		;;
	esac
done
