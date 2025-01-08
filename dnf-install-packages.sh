#!/usr/bin/env bash

echo "Installing packages..."

# This is every single relevant program related to the dotfiles
# (Eg. i3, alacritty, etc.)
sudo dnf install i3 polybar -y
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Installation successful."
