#!/usr/bin/env bash

# Dotfiles install script
# Creates symlinks from dotfiles repo to appropriate locations

set -e

DOTFILES="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

backup_and_link() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # If destination exists and is not a symlink, back it up
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        log_warn "Backing up $dest to $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi

    # Remove existing symlink if it exists
    [[ -L "$dest" ]] && rm "$dest"

    # Create symlink
    ln -s "$src" "$dest"
    log_info "Linked $dest -> $src"
}

echo "Installing dotfiles from $DOTFILES"
echo "=================================="

# Ensure dotfiles directory exists
if [[ ! -d "$DOTFILES" ]]; then
    log_error "Dotfiles directory not found at $DOTFILES"
    exit 1
fi

# Create necessary directories
mkdir -p ~/.config
mkdir -p ~/.local/scripts

# ==========================
# Zsh
# ==========================
log_info "Setting up zsh..."
backup_and_link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES/zsh" "$HOME/.config/zsh"

# ==========================
# Tmux
# ==========================
log_info "Setting up tmux..."
backup_and_link "$DOTFILES/tmux" "$HOME/.config/tmux"
backup_and_link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# ==========================
# Neovim
# ==========================
log_info "Setting up nvim..."
backup_and_link "$DOTFILES/nvim" "$HOME/.config/nvim"

# ==========================
# Ghostty
# ==========================
log_info "Setting up ghostty..."
backup_and_link "$DOTFILES/ghostty" "$HOME/.config/ghostty"

# ==========================
# Git
# ==========================
log_info "Setting up git..."
backup_and_link "$DOTFILES/git" "$HOME/.config/git"

# ==========================
# Starship
# ==========================
log_info "Setting up starship..."
backup_and_link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# ==========================
# Scripts
# ==========================
log_info "Setting up scripts..."
for script in "$DOTFILES"/tmux/scripts/tmux-*; do
    [[ -f "$script" ]] && backup_and_link "$script" "$HOME/.local/scripts/$(basename "$script")"
done

echo ""
echo "=================================="
log_info "Dotfiles installation complete!"

if [[ -d "$BACKUP_DIR" ]]; then
    log_warn "Backups saved to: $BACKUP_DIR"
fi

echo ""
echo "You may need to:"
echo "  - Restart your terminal"
echo "  - Run 'source ~/.zshrc' to reload zsh config"
echo "  - Install tmux plugins: prefix + I (in tmux)"
