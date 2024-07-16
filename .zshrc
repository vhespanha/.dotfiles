# Prompt
eval "$(starship init zsh)"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Set the GPG_TTY to be the same as the TTY, either via the env var
# or via the tty command.
if [ -n "$TTY" ]; then
    export GPG_TTY=$(tty)
else
    export GPG_TTY="$TTY"
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light agkozak/zsh-z
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::golang
zinit snippet OMZP::command-not-found

# Completions
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list '' \
    'm:{a-z\-}={A-Z\_}' \
    'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
    'r:|?=** m:{a-z\-}={A-Z\_}'

zstyle ':completion:*' list-suffixes
zstyle ':completion:*' squeeze-slashes
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color $realpath'
zstyle ":fzf-tab:*" fzf-flags --height=25% --layout=reverse \
    --color "fg:#6a737d,bg:#0f0f0f,hl:#bc8cff,fg+:#bc8cff,bg+:#0f0f0f,hl+:#bc8cff,border:#0f0f0f" \
    --color "info:#6a737d,prompt:#bc8cff,spinner:#bc8cff,pointer:#0f0f0f,marker:#0f0f0f,header:#0f0f0f"

# Environment variables
export EDITOR=nvim
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PATH:/opt:/usr/local/go/bin"
export PATH="$HOME/.npm-global/bin:$HOME/.bun/bin:$HOME/.turso:$HOME/.local/bin:$(go env GOPATH)/bin:$PNPM_HOME:$PATH"

# Go environment variables
export GOPATH=$(go env GOPATH)
export PATH=$PATH:$GOPATH/bin

# NVM configuration
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Pulumi
export PATH=$PATH:/home/vinicius/.pulumi/bin

# Configure pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# History settings
HISTSIZE=2000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots

# Enable interactive comments
setopt interactive_comments

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[5~" beginning-of-history
bindkey "^[[6~" end-of-history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^J" accept-line
bindkey "^M" accept-line
bindkey -r "^[^["

zle_highlight+=(paste:none)

# Aliases
alias ls='eza -a --group-directories-first'
alias la='ls -la'
alias ll='ls -lh'
alias c='clear'
alias md='mkdir -p'
alias sudo='sudo -v; sudo'
alias v='nvim'

eval "$(fzf --zsh)"
