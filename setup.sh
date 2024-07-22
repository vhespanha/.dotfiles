  #!/usr/bin/env bash
  
  function install_software() {
  sleep 20
  sudo apt -o DPkg::Lock::Timeout=600 install build-essential python3-venv socat ncat ruby-dev jq thefuck tmux libfuse2 fuse software-properties-common most -y
  sudo apt remove bat ripgrep -y
  sudo apt-get install -y ca-certificates curl gnupg stow neovim luajit go
  curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | sudo sh -s -- -y
  sudo apt-get update
  export PATH="$PATH:$HOME/.local/bin"
  cargo install ripgrep
  cargo install fd-find
  cargo install bat --locked
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
  
  }
  
  function link_files() {
  mkdir -p ~/.config
  rm ~/.gitconfig
  rm -rf ~/.config/zshrc
  rm -rf ~/.prettierrc
  rm -rf ~/.editorconfig
  rm -rf ~/.config/nvim
  stow .
  }
  
  function setup_software() {
  git clone git@github.com:vhespanha/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
  nvim --headless "+Lazy! sync" +qa
  sudo chsh -s /usr/bin/zsh
  }
  
  echo '🔗 Done!' 
