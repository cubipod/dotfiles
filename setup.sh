#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please run with sudo or as the root user."1>&2
  exit 1
fi

install_packages() {
  echo "Installing software packages..."
  if [ -f ./misc/dnf-packages.txt]; then
    sudo dnf install -y $(cat ./misc/dnf-packages.txt)
    echo "Installation successful"
  else
    echo "Error: dnf-packages.txt not found"
  fi
}

install_tmux_plugins() {
  echo "Installing TMUX plugins..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  bash ~/.tmux/plugins/tpm/bin/install-plugins
  tmux source ~/.tmux.conf
  echo "Installation successful"
}
