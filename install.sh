#!/bin/bash

select_packages() {
    local package_list="$1"
    local -n packages="$package_list"
    local checklist=()

    # Create whiptail checklist
    for ((i=0; i<${#packages[@]}; i+=3)); do
        checklist+=(
            "${packages[i]}"
            "${packages[i+1]}"
            "${packages[i+2]}"

        )
    done

    # Show whiptail menu
    local selected=$(whiptail --title "Select Packages" --checklist "Choose what you want to install:" 25 100 15 "${checklist[@]}" 3>&1 1>&2 2>&3) || return 1

    # Generate command
    local install_command="sudo dnf install -y"

    for package_id in $selected; do
        package_id="${package_id//\"/}"
        install_command+=" $package_id"
    done

    printf '%s\n' "$install_command"
}

# Create log directory
if [ ! -d logs ]; then
    mkdir logs
fi

LOG="logs/install-script-$(date +%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

# Ensure whiptail is installed
if ! command -v whiptail &> /dev/null; then
    sudo dnf install -y newt
fi

clear

# Whiptail theme
export NEWT_COLORS='
    root=white,black
    border=white,black
    window=white,black
    shadow=black,black
    title=yellow,black
    button=black,lightgray
    actbutton=black,cyan
    compactbutton=white,black
    textbox=white,black
    acttextbox=white,black
    entry=white,black
    label=white,black
    listbox=white,black
    actlistbox=black,cyan
    checkbox=white,black
    actcheckbox=black,cyan
'

# Welcome
whiptail --title "Welcome!" --msgbox "Welcome to the Jedora install sciprt. This is made to help you install fedora in various ways. Make sure you know waht you are doing before continuing wiht the instalation. I am not responsible for your mistakes!" 9 80


if ! (whiptail --title "Proceed with Installation?" --yesno "Would you like to proceed?" 7 50); then
    echo Exiting...
    exit 1
fi

# Basic system packages
basic_system_packages=(
    "@core"                    "Smallest possible installation" "ON"
    "@fonts"                   "Fonts packages for rendering text on the desktop." "ON"
    "@hardware-support"        "This group is a collection of tools for various hardware specific utilities." "ON"
    "@multimedia"              "Audio/video framework common to desktops" "ON"
    "@networkmanager-submodules" "This group contains NetworkManager submodules that are commonly used, but may not be wanted in some streamlined configurations." "ON"
    "@printing"                "Install these tools to enable the system to print or act as a print server." "ON"
    "@standard"                "Common set of utilities that extend the minimal installation." "ON"
    "@base-graphical"           "Common packages for any graphical session" "ON"
    "@guest-desktop-agents"     "Agents used when running as a virtualized desktop." "OFF"
    "@dial-up"                  "No description available" "ON"
    "@input-methods"            "Input method packages for the input of international text." "ON"
    "@admin-tools"              "This group is a collection of graphical administration tools for the system, such as for managing user accounts and configuring system hardware." "ON"
)

basic_system_packages_command=$(select_packages basic_system_packages)
echo "$basic_system_packages_command"

# Hyprland packages
hyprland_packages=(
    "hyprland" "Wayland compositor and desktop environment" "ON"
    "xdg-desktop-portal" "Portal service for desktop integration and sandboxed applications" "ON"
    "xdg-desktop-portal-hyprland" "Hyprland backend for xdg-desktop-portal" "ON"
    "xorg-x11-server-Xwayland" "X11 compatibility server for running X11 applications on Wayland" "ON"
    "sddm" "Graphical login manager for starting desktop sessions" "ON"
    "rofi" "Application launcher and window switcher" "ON"
    "kitty" "Fast, feature-rich terminal emulator" "ON"
    "waybar" "Highly customizable status bar for Wayland" "ON"
    "hyprpaper" "Blazing fast Wayland wallpaper utility" "ON"
    "thunar" "Lightweight file manager for Linux desktops" "ON"
    "hyprpolkitagent" "Polkit authentication agent for Hyprland" "ON"
)

hyprland_packages_command=$(select_packages hyprland_packages)
echo "$hyprland_packages_command"

# Extra packages
extra_packages=(
    "btop" "Resource monitor for the terminal" "OFF"
    "fastfetch" "System information and hardware summary tool" "ON"
    "swaylock" "Screen locker for Wayland/Sway" "ON"
    "swayidle" "Idle management daemon for Wayland/Sway" "ON"
    "playerctl" "Command-line control for media players using MPRIS" "OFF"
    "brightnessctl" "Command-line utility for controlling screen/backlight brightness" "OFF"
    "wl-clipboard" "Wayland clipboard utilities (wl-copy and wl-paste)" "OFF"
)

extra_packages_command=$(select_packages extra_packages)
echo "$extra_packages_command"




