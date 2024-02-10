#!/bin/bash
#installation script for pot -> creating the pot directory and pothocks.txt file
HOOKS=$HOME/.config/rofi/pot/pothooks.txt
HOOKSPATH=$HOME/.config/rofi/pot

CHECKDIR=$(test -d "$HOOKSPATH" && echo "true" || echo "false")
CHECK=$(test -f "$HOOKS" && echo "true" || echo "false")

echo "Pot installation script"
sleep 1
echo "Checking if pot directory and file is installed"
sleep 1
echo "starting installation"
sleep 1

if [[ "$CHECKDIR" == "false" ]]; then
	echo "starting installation of dir"
	mkdir "$HOOKSPATH"
	sleep 1
elif [[ "$CHECK" == "false" ]]; then
	echo "starting installation of file"
	echo "pot" >"$HOOKS"
	sleep 1
fi

echo "Basic Installation Complete"
sleep 1
echo "Checking if dependencies are installed"
sleep 1
# Check if dmenu or rofi exists
echo "Checking if dmenu or rofi exists"
sleep 1
if ! command -v dmenu >/dev/null 2>&1 && ! command -v rofi >/dev/null 2>&1; then
	echo "dmenu or rofi is not installed."
	sleep 1
else
	echo "dmenu or rofi are installed."
	sleep 1
fi

# Check if dunstify exists
echo "Checking if dunstify exists"
sleep 1
if ! command -v dunstify >/dev/null 2>&1; then
	echo "dunstify is not installed."
	sleep 1
else
	echo "dunstify is installed."
	sleep 1
fi

# Check if xclip or xsel exists
echo "Checking if xclip or xsel exists"
sleep 1
if ! command -v xclip >/dev/null 2>&1 && ! command -v xsel >/dev/null 2>&1; then
	echo "xclip or xsel is not installed."
	sleep 1
else
	echo "xclip or xsel are installed."
	sleep 1
fi

echo "Installation Complete"
echo "Check ~/.config/rofi/pot directory for all files"
