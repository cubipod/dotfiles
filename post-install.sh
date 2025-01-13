#!/usr/bin/env bash

# Requires sudo privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please run with sudo or as the root user."
  exit 1
fi

# Variables
USERNAME="$(logname)"
HOME_DIR="/home/$USERNAME"

install() {
  # Install packages
  echo "Installing necessary packages..."
  if [ -f ./misc/dnf-packages.txt ]; then
    sudo dnf install -y $(cat ./misc/dnf-packages.txt)
    echo "Installation successful"
  else
    echo "Error: dnf-packages.txt not found"
  fi

  # Install fonts
  echo "Installing necessary fonts..."
  mkdir .temp
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
  tar -xf Hack.tar.xz -C .temp
  sudo mv .temp/*.ttf /usr/share/fonts
  fc-cache -f
  rm -rf .temp
  rm -rf Hack.tar.xz
  echo "Font installation successful"

  # Configure terminal
  echo "Configuring the terminal..."
  chsh -s $(which zsh)
  chsh -s $(which zsh) $USERNAME
  mkdir -p $HOME_DIR/.local/bin
  git clone https://github.com/NvChad/starter $HOME_DIR/.config/nvim
  git clone https://github.com/tmux-plugins/tpm $HOME_DIR/.tmux/plugins/tpm

  # Add dotfiles
  echo "Inserting dotfiles..."
  stow -t $HOME_DIR configurations

  # Download desktop background
  echo "Dowloading desktop background..."
  wget "https://cdnb.artstation.com/p/assets/images/images/006/189/743/large/denis-istomin-sky-110517-b-v2-2-f.jpg?1496688610" -O $HOME_DIR/Pictures/Quiet_by_Denis_Istomin.jpg

  reload_all
}

reload_all() {
  echo "Reloading..."
  fc-cache -f
  i3-msg restart
  tmux source $HOME_DIR/.tmux.conf
  echo "Reload successful"
  echo "(Note: Some apps need to be closed to reload, such as Alacritty)"
}

reboot_now() {
  echo "Script complete. Rebooting..."
  reboot
}

dont_reboot() {
  echo "Script complete. Some changes might not be visible until the next reboot."
}

echo "Please select what you'd like to do"
echo "1) Install necessary packages and configurations"
echo "3) Install miscellaneous packages (Steam, Discord, etc.)"

read -p "Select: " choice

case $choice in
  1) install ;;
  2) install_misc ;;
  *) echo "Invalid option, please try again"
esac

read -p "A reboot is required in order to apply some of the changes. Would you like to do this now? [y/n]" reboot_choice
case $reboot_choice in
  y) reboot_now ;;
  n) dont_reboot ;;
  *) echo "Invalid option, skipping reboot." ;;
esac