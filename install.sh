#!/usr/bin/env bash

set -e

echo "=== Jual's Fedora + Hyprland install script ==="

echo
echo "=== Updating Fedora ==="
sudo dnf upgrade --refresh -y

echo
echo "=== Installing Fedora foundation ==="
sudo dnf install -y \
    @base-x \
    @core \
    @fonts \
    @hardware-support \
    @multimedia \
    @networkmanager-submodule \
    @printing

echo
echo "=== Enabling Hyprland repository ==="
sudo dnf copr enable -y lionheartp/hyprland

echo
echo "=== Installing Hyprland desktop ==="
sudo dnf install -y \
    hyprland \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    xorg-x11-server-Xwayland \
    sddm \
    rofi \
    kitty \
    waybar \
    hyprpaper \
    thunar \
    hyprpolkitagent

echo
echo "=== Installing useful extras ==="
sudo dnf install -y \
    btop \
    fastfetch \
    swaylock \
    swayidle \
    playerctl \
    brightnessctl \
    wl-clipboard

echo
echo "=== Configuring graphical boot ==="
sudo systemctl enable sddm
sudo systemctl set-default graphical.target

echo
echo "=== Setup complete ==="
echo "Reboot your computer to start SDDM and Hyprland."
