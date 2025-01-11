#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please run with sudo or as the root user."
  exit 1
fi

# Misc variables
USERNAME="$(logname)"
HOME_DIR="/home/$USERNAME"

install_packages() {
  echo "Installing packages..."
  if [ -f ./misc/dnf-packages.txt ]; then
    sudo dnf install -y $(cat ./misc/dnf-packages.txt)
    echo "Installation successful"
  else
    echo "Error: dnf-packages.txt not found"
  fi
}

install_fonts() {
  echo "Installing fonts..."
  mkdir .temp
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
  tar -xf Hack.tar.xz -C .temp
  sudo mv .temp/*.ttf /usr/share/fonts
  fc-cache -f
  rm -rf .temp
  rm -rf Hack.tar.xz
  echo "Font installation successful" 
}

load_configurations() {
  echo "Configuring shell (zsh)..."
  chsh -s $(which zsh)
  chsh -s $(which zsh) $USERNAME
  mkdir -p $HOME_DIR/.local/bin
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME_DIR/.local/bin -t $HOME_DIR/.cache/oh-my-posh/themes

  echo "Inserting dot=files..."
  stow -t $HOME_DIR ./alacritty
  stow -t $HOME_DIR ./i3
  stow -t $HOME_DIR ./polybar
  stow -t $HOME_DIR ./tmux
  stow -t $HOME_DIR ./zsh

  echo "Installing TMUX plugins..."
  mkdir -p $HOME_DIR/.tmux/plugins/tmux-sensible
  mkdir -p $HOME_DIR/.tmux/plugins/tmux-plugins/cpu
  mkdir -p $HOME_DIR/.tmux/plugins/catppuccin/tmux
  git clone https://github.com/tmux-plugins/tmux-sensible.git $HOME_DIR/.tmux/plugins/tmux-sensible
  git clone https://github.com/catppuccin/tmux.git $HOME_DIR/.tmux/plugins/catppuccin/tmux
  git clone https://github.com/tmux-plugins/tmux-cpu $HOME_DIR/.tmux/plugins/tmux-plugins/cpu
  tmux source $HOME_DIR/.tmux.conf

  echo "Getting background..."
  wget "https://cdnb.artstation.com/p/assets/images/images/006/189/743/large/denis-istomin-sky-110517-b-v2-2-f.jpg?1496688610" -O $HOME_DIR/Pictures/Quiet_by_Denis_Istomin.jpg
}

reload_all() {
  echo "Reloading..."
  fc-cache -f
  i3-msg restart
  tmux source $HOME_DIR/.tmux.conf
  echo "Reload successful"
  echo "Note: Some apps need to be closed to reload. This includes: Alacritty"
}

execute_all() {
  install_packages
  install_fonts
  load_configurations
  reload_all
}

reboot_now() {
  echo "Setup complete. Rebooting..."
  reboot
}

dont_reboot() {
  echo "Setup complete. Some changes might not be visible until the next reboot."
}

echo "Please select what you'd like to do"
echo "1) Install packages"
echo "2) Install fonts"
echo "3) Load configurations"
echo "4) Reload all"
echo "5) All of the above"

read -p "Select: " choice

case $choice in
  1) install_packages ;;
  2) install_fonts ;;
  3) load_configurations ;;
  4) reload_all ;;
  5) execute_all ;;
  *) echo "Invalid option, please try again"
esac

read -p "A reboot is required in order to apply some of the changes. Would you like to do this now? [y/n]" reboot_choice
case $reboot_choice in
  y) reboot_now ;;
  n) dont_reboot ;;
  *) echo "Invalid option, skipping reboot." ;;
esac