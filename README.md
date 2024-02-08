# Pot V_Alpha

Pot is a bash script that provides a convenient menu-driven interface for managing paths stored in a file. It allows users to easily add, delete, or choose paths from a list using interactive menus. This script is particularly useful for managing lists of directories or file paths used in various applications or scripts.

## Features

- **Add Path**: Add a new path to the list stored in the `pothooks.txt` file.
- **Delete Path**: Remove a path from the list.
- **Choose Path**: Select a path from the list to copy it to the clipboard for further use.
- **Help Mode**: Access a detailed explanation of each available option and how to use them.

## Prerequisites

- Bash/Zsh
- Rofi
- Dunstify (optional)

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Dovshmi/pot.git
    ```

2. Make the script executable:

    ```bash
    chmod +x pot.sh
    ```

3. Optionally, you can add the repository directory to your PATH for easier access:

    ```bash
    export PATH="$PATH:/path/to/pot"
    ```

## Usage

1. **Run the script**:

    ```bash
    ./pot.sh
    ```

2. **Main Menu Options**:

    - **Add Path**: Append a new path to the list in the `pothooks.txt` file.
    - **Delete Path**: Remove a path from the list.
    - **Choose Path**: Select a path from the list to copy it to the clipboard.
    - **Help Mode**: Get detailed instructions on how to use each option.

3. **Editing Modes**:
    - **Add Mode**: Input a new path to append to the list.
    - **Delete Mode**: Select a path to delete from the list.
    - **Help Mode**: Detailed instructions for each editing mode.

## `pothooks.txt` File

The `pothooks.txt` file stores the list of paths managed by Pot. Each line in the file represents a single path. The script ensures that duplicate paths are removed, and the list is sorted alphabetically for easier management.

##Adding Keybinds in Different Window Managers

### 1. i3 Window Manager

Add the following line to your `~/.config/i3/config` file:
```plaintext
bindsym $mod+p exec /path/to/pot.sh
```
### 2. Xmonad Window Manager
Add the following line to your ~/.xmonad/xmonad.hs file:
```plaintext
, ((modm, xK_p), spawn "/path/to/pot.sh")
```

### 3.Awesome Window Manager

Add the following line to your ~/.config/awesome/rc.lua file:
```lua
awful.key({ modkey }, "p", function () awful.util.spawn("/path/to/pot.sh") end,
          {description = "Open Pot", group = "launcher"}),
```
### 4. Openbox Window Manager

Add the following line to your ~/.config/openbox/rc.xml file inside the <keyboard> section:
```xml
<keybind key="A-p">
  <action name="Execute">
    <command>/path/to/pot.sh</command>
  </action>
</keybind>
```

## Screenshots

Include screenshots here to visually demonstrate the script's usage.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [MIT License](LICENSE).
Made By Rony Shmidov
