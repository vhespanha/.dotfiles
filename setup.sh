#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status

function install_software() {
  echo "Installing software packages..."
  sleep 20
  sudo apt-get update
  sudo apt-get install -o DPkg::Lock::Timeout=600 -y build-essential python3-venv socat ncat ruby-dev jq thefuck tmux libfuse2 fuse software-properties-common most
  sudo apt-get remove -y bat ripgrep
  sudo apt-get install -y ca-certificates curl gnupg stow neovim luajit golang-go
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export PATH="$PATH:$HOME/.local/bin"
  cargo install ripgrep
  cargo install fd-find
  cargo install bat --locked
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
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
  git clone git@github.com:vhespanha/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  nvim --headless "+Lazy! sync" +qa
  sudo chsh -s /usr/bin/zsh
}

# Main script execution
install_software
link_files
setup_software

echo '🔗 Done!'
