# ==========================
# Tool Initializations
# ==========================

# Starship prompt
eval "$(starship init zsh)"

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"
alias cd='z'
alias cdi='zi'

# Bun completions
[ -s "/Users/harshtiwari/.bun/_bun" ] && source "/Users/harshtiwari/.bun/_bun"

# Zsh plugins (loaded via oh-my-zsh, but syntax highlighting needs explicit source)
[ -f ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
