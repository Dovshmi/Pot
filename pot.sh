#!/bin/bash

HOOKS="$HOME/.local/share/pot/pothooks.txt"
CHECK=$(test -f "$HOOKS" && echo "true" || echo "false")

#TAG if no theme used && Tag if theme exists check line below
THEME="$HOME/.config/rofi/launchers/type-1/style-8.rasi"
[[ ! -f "$THEME" ]] && THEME="" || THEME="-theme $THEME"

#Untag if using dmenu and tag rofi
MENU="rofi -dmenu $THEME -mesg "
#MENU="dmenu -l 100 -p "

# Display a message using dunst $1 -> massage for the user $2 -> icon name
notify() {
	#Tag dunsity and Untag echo if dunst is not used
	dunstify "$1" -i "$2" -t 6000
	#echo "$1"
}

if [[ "$CHECK" == "false" ]]; then
	notify "Cannot find pothooks.txt, needs install.sh" "danger"
	exit
fi

if command -v xclip >/dev/null 2>&1; then
	clipboard_command="xclip -rmlastnl -selection clipboard"
# Check if xsel is available
elif command -v xsel >/dev/null 2>&1; then
	clipboard_command="xsel -i -b"
else
	# Display error notification if neither xclip nor xsel is available
	notify "Clipboard copy failed: xclip and xsel not found" "warning"
	exit 1
fi

HOOKSSORTED=$(sort "$HOOKS" | uniq)
echo "$HOOKSSORTED" | tr ' ' '\n' >"$HOOKS"

delete_mode() {
	foo=$(cat "$HOOKS" | ${MENU} "Delete Mode : [ Enter - Delete ] [ESC]")
	sed -i "\|^${foo}$|d" "$HOOKS"
}

append_mode() {
	foo=$(${MENU} "Append Mode : [ Enter - Append ] [ESC]")
	if [ -n "$foo" ]; then
		echo "$foo" >>"$HOOKS"
	fi
}

while true; do
	foo=$(
		cat "$HOOKS" | ${MENU} "Normal Mode : [ D/[-] -> Delete ] [ A/[+] -> Append ] [ Enter -> Choose ] [ ? -> Help ] [ESC]"
	)
	case $foo in
	":d" | "delete" | "Delete" | ":D" | "-")
		notify "Delete Mode" "danger"
		delete_mode
		;;
	":a" | "add" | "Add" | ":A" | "append" | "Append" | "+")
		notify "Append Mode" "danger"
		append_mode
		;;
	"?" | ":?" | "help" | "HELP")
		HELP=$(echo -e "Normal Mode -> Main hooked paths choosing menu\nDelete Mode -> Delete from hooked paths\nAppend Mode -> Append to hooked paths\nExit -> Exit" |
			${MENU} "Help Mode : [Enter - Choose] [ESC]")
		HELP=$(echo $HELP | awk '{print $1}')
		case "$HELP" in
		"Delete")
			notify "Delete Mode" "danger"
			delete_mode

			;;
		"Append")
			notify "Append Mode" "danger"

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
			echo "$foo" | $clipboard_command || notify "Clipboard copy failed" "danger"
			notify "Clipboard Loaded" "notification"
			break
		fi
		;;
	esac
done
