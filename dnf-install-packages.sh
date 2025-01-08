#!/usr/bin/env bash

echo "Installing packages..."

# This is every single relevant program related to the dotfiles
# (Eg. i3, alacritty, etc.)

sudo dnf install alacritty i3 jetbrains-mono-fonts-all polybar

echo "Installation successful."
