# ==========================
# Aliases
# ==========================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias home='cd ~'
alias desk='cd ~/Desktop'
alias down='cd ~/Downloads'
alias proj='cd ~/Projects'

# Editor
alias v='nvim'
alias vim='nvim'

# Git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gl='git log --oneline --graph --all'
alias gco='git checkout'
alias gpf='git push --force-with-lease'
alias lz='lazygit'

# Tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# Modern CLI replacements (eza, bat, fd, dust, rg)
if command -v eza &> /dev/null; then
  alias ls='eza --color=auto --icons --group-directories-first'
  alias la='eza -la --color=auto --icons --group-directories-first'
  alias ll='eza -l --color=auto --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons --group-directories-first'
  alias lta='eza --tree --level=2 --icons -a --group-directories-first'
  alias lg='eza -la --git --icons --group-directories-first'
else
  alias ls='lsd --color=auto'
  alias lsa='lsd -a'
  alias lsl='lsd -l'
  alias lsla='lsd -la'
  alias tree='lsd --tree'
fi

alias cat='bat --style=plain --color=always'
alias bat='bat --style=plain --color=always'
alias fd='fd --hidden --exclude .git'
alias du='dust -d 2'
alias grep='rg --hidden --glob "!.git/*"'
alias btm='bottom --color true'

# File operations
alias mkd='mkdir -p'
alias cp='cp -rv'
alias mv='mv -v'
alias rm='rm -iv'

# General utilities
alias c='clear'
alias h='history'
alias reload='source ~/.zshrc'
alias ports='netstat -tulanp 2>/dev/null || lsof -i -P -n | grep LISTEN'
alias p='ping -c 3 8.8.8.8'
alias myip='curl -s https://api.ipify.org'
alias size='du -sh * | dust -d 1'
alias json='jq .'
alias jsonl='jq -c'
alias psx='ps aux | grep -v grep | grep'
