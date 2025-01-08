#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please run with sudo or as the root user."
  exit 1
fi

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
  mkdir ./temp
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
  tar -xf Hack.tar.xz -C ./temp
  sudo mv ./temp/*.ttf /usr/share/fonts
  fc-cache -f
  rm -rf ./temp Hack.tar.xz
  echo "Font installation successful" 
}

load_configurations() {
  echo "Setting zsh as the default shell..."
  chsh -s $(which zsh)

  echo "Loading configurations..."
  stow configurations/i3
  stow configurations/polybar
  stow configurations/tmux

  echo "Installing TMUX plugins"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  bash ~/.tmux/plugins/tpm/bin/install-plugins
  tmux source ~/.tmux.conf
}

reload_all() {
  echo "Reloading..."
  fc-cache -f
  i3-msg restart
  tmux source ~/.tmux.conf
  echo "Reload successful"
  echo "Note: Some apps need to be closed to reload. This includes: Alacritty"
}

execute_all() {
  install_packages
  install_fonts
  load_configurations
  reload_all 
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
