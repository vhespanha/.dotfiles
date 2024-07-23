#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

function install_software() {
  echo "Installing software packages..."
  sudo apt-get update
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y build-essential jq software-properties-common
  sudo apt-get install -y ca-certificates curl gnupg stow neovim luajit fd-find ripgrep fzf
  sudo curl -sS https://starship.rs/install.sh | sh -s -- -y
}

function link_files() {
  echo "Linking configuration files..."
  mkdir -p ~/.config
  rm -f ~/.gitconfig
  rm -rf ~/.zshrc ~/.prettierrc ~/.editorconfig ~/.config/nvim
  stow --dotfiles --adopt .
}

function setup_software() {
  echo "Setting up software..."
  if [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ]; then
    git clone https://github.com/vhespanha/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  else
    echo "nvim configuration already exists, skipping clone."
  fi
  sudo chsh -s /usr/bin/zsh
}

# Main script execution
echo "Starting setup script..."
install_software
link_files
setup_software
echo "🔗 Done!"
