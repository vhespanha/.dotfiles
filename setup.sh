#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

LOG_FILE="/home/gitpod/.dotfiles.log"

# Ensure the script has permission to write to the log file
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

function log() {
  echo "$1" | tee -a "$LOG_FILE"
}

function install_software() {
  log "Installing software packages..."
  sudo apt-get update
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y build-essential jq software-properties-common
  sudo apt-get install -y ca-certificates curl gnupg stow neovim luajit fd-find ripgrep fzf
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
}

function link_files() {
  log "Linking configuration files..."
  mkdir -p ~/.config
  rm -f ~/.gitconfig
  rm -rf ~/.config/zshrc ~/.prettierrc ~/.editorconfig ~/.config/nvim
  stow --dotfiles .
}

function setup_software() {
  log "Setting up software..."
  if [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ]; then
    git clone https://github.com/vhespanha/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  else
    log "nvim configuration already exists, skipping clone."
  fi
  sudo chsh -s /usr/bin/zsh
}

# Main script execution
log "Starting setup script..."
install_software
link_files
setup_software
log "🔗 Done!"
