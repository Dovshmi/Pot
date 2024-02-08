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

delete_mode() {
	foo=$(cat "$HOOKS" | ${MENU} -mesg "Delete Mode : [ Enter - Delete ] [ESC]" -theme "$THEME")
	sed -i "\|^${foo}$|d" "$HOOKS"
}

append_mode() {
	foo=$(${MENU} -mesg "Append Mode : [ Enter - Append ] [ESC]" -theme "$THEME")
	if [ -n "$foo" ]; then
		echo "$foo" >>"$HOOKS"
	fi
}

while true; do
	foo=$(
		cat "$HOOKS" | ${MENU} -mesg "Normal Mode : [ D/[-] -> Delete ] [ A/[+] -> Append ] [ Enter -> Choose ] [ ? -> Help ] [ESC]" -theme "$THEME"
	)
	case $foo in
	"d" | "delete" | "Delete" | "D" | "-")
		dunstify "Delete Mode " -i danger -t 6000
		delete_mode
		;;
	"a" | "add" | "Add" | "A" | "append" | "Append" | "+")
		dunstify "Append Mode " -i danger -t 6000
		append_mode
		;;
	"?")
		HELP=$(echo -e "Normal Mode -> Main hooked paths choosing menu\nDelete Mode -> Delete from hooked paths\nAppend Mode -> Append to hooked paths\nExit -> Exit" |
			${MENU} -mesg "Help Mode : [Enter - Choose] [ESC]" -e - -theme "$THEME")
		HELP=$(echo $HELP | awk '{print $1}')
		case "$HELP" in
		"Delete")
			dunstify "Delete Mode " -i danger -t 6000
			delete_mode

			;;
		"Append")
			dunstify "Append Mode " -i danger -t 6000
			append_mode
			;;
		"Exit")
			break
			;;
		*)
			echo default
			;;
		esac
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
