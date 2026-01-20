#!/usr/bin/env bash

# Dotfiles install script
# Installs dependencies and creates symlinks

set -e

DOTFILES="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_section() { echo -e "\n${BLUE}==>${NC} $1"; }

# ==========================
# Dependency Installation
# ==========================

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to PATH for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew already installed"
    fi
}

install_if_missing() {
    local cmd="$1"
    local pkg="${2:-$1}"

    if ! command -v "$cmd" &> /dev/null; then
        log_info "Installing $pkg..."
        brew install "$pkg"
    else
        log_info "$pkg already installed"
    fi
}

install_cask_if_missing() {
    local app="$1"
    local cask="$2"

    if ! brew list --cask "$cask" &> /dev/null; then
        log_info "Installing $cask..."
        brew install --cask "$cask"
    else
        log_info "$cask already installed"
    fi
}

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi
}

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        log_info "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        log_info "zsh-syntax-highlighting already installed"
    fi
}

install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        log_info "TPM already installed"
    fi
}

backup_and_link() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        log_warn "Backing up $dest"
        mv "$dest" "$BACKUP_DIR/"
    fi

    [[ -L "$dest" ]] && rm "$dest"

    ln -s "$src" "$dest"
    log_info "Linked $(basename "$dest")"
}

# ==========================
# Main Installation
# ==========================

echo "=================================="
echo "  Dotfiles Installation Script"
echo "=================================="

if [[ ! -d "$DOTFILES" ]]; then
    log_error "Dotfiles directory not found at $DOTFILES"
    exit 1
fi

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
    *)      log_error "Unsupported OS: $OS"; exit 1 ;;
esac

log_info "Detected OS: $OS"

# ==========================
# Install Dependencies
# ==========================

log_section "Installing dependencies..."

if [[ "$OS" == "macos" ]]; then
    install_homebrew

    # Core tools
    log_section "Core tools"
    install_if_missing zsh
    install_if_missing tmux
    install_if_missing nvim neovim
    install_if_missing git

    # CLI enhancements
    log_section "CLI tools"
    install_if_missing fzf
    install_if_missing starship
    install_if_missing zoxide
    install_if_missing bat
    install_if_missing eza
    install_if_missing fd
    install_if_missing rg ripgrep
    install_if_missing dust
    install_if_missing lazygit
    install_if_missing jq
    install_if_missing btm bottom

    # Optional: Ghostty terminal (uncomment if desired)
    # log_section "Applications"
    # install_cask_if_missing ghostty ghostty

elif [[ "$OS" == "linux" ]]; then
    log_warn "Linux detected. Please install dependencies manually or modify this script."
    log_warn "Required: zsh tmux neovim git fzf starship zoxide bat eza fd ripgrep"
    echo ""
    read -p "Continue with symlink setup? [y/N] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi

# ==========================
# Zsh Setup
# ==========================

log_section "Setting up Zsh..."
install_oh_my_zsh
install_zsh_plugins

# ==========================
# Tmux Setup
# ==========================

log_section "Setting up Tmux..."
install_tpm

# ==========================
# Create Symlinks
# ==========================

log_section "Creating symlinks..."

mkdir -p ~/.config
mkdir -p ~/.local/scripts
mkdir -p ~/.local/bin

# Zsh
backup_and_link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES/zsh" "$HOME/.config/zsh"

# Tmux
backup_and_link "$DOTFILES/tmux" "$HOME/.config/tmux"
backup_and_link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Neovim
backup_and_link "$DOTFILES/nvim" "$HOME/.config/nvim"

# Ghostty
backup_and_link "$DOTFILES/ghostty" "$HOME/.config/ghostty"

# Git
backup_and_link "$DOTFILES/git" "$HOME/.config/git"

# Starship
backup_and_link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

# Scripts
for script in "$DOTFILES"/tmux/scripts/tmux-*; do
    [[ -f "$script" ]] && backup_and_link "$script" "$HOME/.local/scripts/$(basename "$script")"
done

# ==========================
# Post-install
# ==========================

log_section "Post-installation steps"

# Set zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    log_info "Setting zsh as default shell..."
    chsh -s "$(which zsh)" || log_warn "Could not change shell. Run: chsh -s \$(which zsh)"
fi

# Install fzf keybindings
if [[ ! -f "$HOME/.fzf.zsh" ]]; then
    log_info "Setting up fzf keybindings..."
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
fi

echo ""
echo "=================================="
log_info "Installation complete!"
echo "=================================="

if [[ -d "$BACKUP_DIR" ]]; then
    log_warn "Backups saved to: $BACKUP_DIR"
fi

echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Open tmux and press: prefix + I (to install tmux plugins)"
echo "  3. Open nvim and let Lazy install plugins automatically"
echo ""
