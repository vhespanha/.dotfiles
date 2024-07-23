#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

function install_software() {
  echo "Installing software packages..."
  sudo apt-get update
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y build-essential jq software-properties-common
  sudo apt-get install -y ca-certificates curl gnupg stow neovim luajit fd-find ripgrep fzf
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
}

function link_files() {
  echo "Linking configuration files..."
  mkdir -p ~/.config
  rm -f ~/.gitconfig
  rm -rf ~/.config/zshrc ~/.prettierrc ~/.editorconfig ~/.config/nvim
  stow --dotfiles .
}

function setup_software() {
  echo "Setting up software..."
  git clone https://github.com/vhespanha/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  sudo chsh -s /usr/bin/zsh
}

# Main script execution
install_software
link_files
setup_software

echo '🔗 Done!'
