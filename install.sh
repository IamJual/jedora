#!/bin/sh

# Create log directory
if [ ! -d logs ]; then
    mkdir logs
fi

LOG="logs/install-script-$(date +%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

if ! command -v whiptail &> /dev/null; then
    sudo dnf install -y newt
fi

clear

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


# Welcome prompt
whiptail --title "Welcome!" --msgbox "Welcome to the Jedora install sciprt. This is made to help you install fedora in various ways. Make sure you know waht you are doing before continuing wiht the instalation. I am not responsible for your mistakes!" 9 80


if ! (whiptail --title "Proceed with Installation?" --yesno "TWould you like to proceed?" 7 50); then
    echo Exiting...
    exit 1
fi

# Fedora foundation

