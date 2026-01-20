# ==========================
# FZF Configuration
# ==========================

# Base options (no preview by default)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Ctrl+R history: no preview
export FZF_CTRL_R_OPTS="--preview-window hidden"

# Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# File/directory commands
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --hidden --exclude .git'

# Preview configuration
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always --icons {} | head -200; else bat -n --color=always --line-range :500 {} 2>/dev/null || cat {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons {} | head -200'"

# FZF aliases
alias fzf='fzf --preview "bat --style=plain --color=always {}"'
alias ff='fzf --height 40% --reverse --info hidden --bind "ctrl-/:toggle-preview"'
alias fcd='cd $(fd --type d | fzf --height 40% --reverse)'
alias ffile='fd | fzf --height 40% --reverse | xargs bat'
