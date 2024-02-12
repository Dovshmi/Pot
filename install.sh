#!/bin/bash

# Set installation paths
HOOKS="$HOME/.local/share/pot/pothooks.txt"
HOOKSPATH="$HOME/.local/share/pot"
BIN_PATH="/usr/bin/pot"
SCRIPT_NAME="pot.sh"

# Function to check and install directory
install_directory() {
	if [[ ! -d "$HOOKSPATH" ]]; then
		echo "Pot main directory is not installed. Starting installation..."
		mkdir -p "$HOOKSPATH" || {
			echo "Failed to create pot directory."
			exit 1
		}
		echo "Pot main directory installed."
	else
		echo "Pot main directory is already installed."
	fi
}

# Function to check and install pothooks.txt file
install_pothooks() {
	if [[ ! -f "$HOOKS" ]]; then
		echo "Pot Data file is not installed. Starting installation..."
		echo "$HOOKSPATH" >"$HOOKS" || {
			echo "Failed to create pothooks.txt file."
			exit 1
		}
		echo "Pot Data file installed."
	else
		echo "Pot Data file is already installed."
	fi
}

# Function to create or refresh symlink for /usr/bin/pot
create_symlink() {
	read -p "Do you want to create a symlink for /usr/bin/pot? (yes/no): " choice
	case "$choice" in
	yes)
		if [[ -L "$BIN_PATH" ]]; then
			echo "Removing old version of pot from /usr/bin..."
			sudo rm "$BIN_PATH" || {
				echo "Failed to remove old symlink."
				exit 1
			}
		fi
		DIRNAME="$(realpath "$0")"
		REALNAME="$DIRNAME/$SCRIPT_NAME"
		echo "Creating symlink for pot in /usr/bin..."
		sudo ln -s "$REALNAME" "$BIN_PATH" || {
			echo "Failed to create symlink."
			exit 1
		}
		echo "Symlink created successfully."
		;;
	no)
		echo "Skipping symlink creation."
		;;
	*)
		echo "Invalid choice. Please enter 'yes' or 'no'."
		create_symlink
		;;
	esac
}

# Function to prompt user for install or reinstall
prompt_install() {
	read -p "Do you want to install or reinstall the script command line shortcut? (install/reinstall): " choice
	case "$choice" in
	install)
		install_directory
		install_pothooks
		create_symlink
		;;
	reinstall)
		install_pothooks
		create_symlink
		;;
	*)
		echo "Invalid choice. Please enter 'install' or 'reinstall'."
		prompt_install
		;;
	esac
}

# Function to prompt user to check for dependencies
prompt_dependencies() {
	read -p "Do you want to check for dependencies? (yes/no): " choice
	case "$choice" in
	yes)
		check_dependencies
		;;
	no) ;;
	*)
		echo "Invalid choice. Please enter 'yes' or 'no'."
		prompt_dependencies
		;;
	esac
}

# Function to check for dependencies
check_dependencies() {
	echo "Checking if dependencies are installed..."
	dependencies=("dmenu" "rofi" "dunstify" "xclip" "xsel")
	for dep in "${dependencies[@]}"; do
		if command -v "$dep" >/dev/null 2>&1; then
			echo "$dep is installed."
		else
			echo "$dep is not installed."
		fi
	done
}

# Main script starts here
echo "Pot installation script"
echo "Path for Pot Chosen: $HOOKSPATH"
echo "Path for Saved Data Chosen: $HOOKS"

# Check and install directory
#install_directory

# Check and install pothooks.txt file
#install_pothooks

# Prompt user for install or reinstall
prompt_install

# Prompt user to check for dependencies
prompt_dependencies

echo "Installation Complete. Check $HOOKSPATH directory for all files."
