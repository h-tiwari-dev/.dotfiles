<div align="center">

# ⚡ Dotfiles

### My personal development environment configuration

[![MacOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-FFFFFF?style=for-the-badge&logo=gnu-bash&logoColor=black)](https://www.gnu.org/software/bash/)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

A meticulously crafted collection of configuration files and scripts to set up a **beautiful**, **productive**, and **consistent** development environment on macOS and Linux.

</div>

## Overview

This repository contains configurations for my daily driver tools, focusing on a terminal-centric workflow.

### Key Components

- **Shell:** [Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/)
- **Prompt:** [Starship](https://starship.rs/)
- **Editor:** [Neovim](https://neovim.io/) (based on [LazyVim](https://www.lazyvim.org/))
- **Terminal Multiplexer:** [Tmux](https://github.com/tmux/tmux) with [TPM](https://github.com/tmux-plugins/tpm)
- **Terminal Emulator:** [Ghostty](https://ghostty.org/)
- **CLI Tools:**
  - `fzf` (Fuzzy finder)
  - `zoxide` (Smarter cd)
  - `eza` (Modern ls replacement)
  - `bat` (Cat clone with syntax highlighting)
  - `ripgrep` (Fast grep)
  - `lazygit` (Git TUI)
  - `bottom` (System monitor)

## Installation

### Automatic Installation (macOS)

The `install.sh` script is designed to automate the entire process on macOS using Homebrew.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```
   This script will:
   - Install Homebrew (if missing)
   - Install all required dependencies (zsh, neovim, tmux, etc.)
   - Install Oh My Zsh and Zsh plugins
   - Install Tmux Plugin Manager
   - Backup existing configurations to `~/.dotfiles_backup/`
   - Create symbolic links for all configurations

### Linux Installation

For Linux users, the script will skip the package installation step (Homebrew) and proceed to setup symlinks. You must install the dependencies manually first:

```bash
# Example for Ubuntu/Debian
sudo apt install zsh tmux neovim git fzf fd-find ripgrep bat
# Note: Some newer tools like zoxide, eza, lazygit may need to be installed manually or via other package managers.
```

Then run the script:
```bash
./install.sh
```

## Post-Installation

After the script completes:

1. **Restart your shell** or run `source ~/.zshrc` to apply changes.
2. **Tmux:** Open tmux and press `prefix` + `I` (default prefix is usually `Ctrl+b` or `Ctrl+a` depending on config) to install plugins.
3. **Neovim:** Open `nvim`. Lazy.nvim will automatically install all plugins on the first launch.

## File Structure

- **`install.sh`**: Main setup script.
- **`zsh/`**: Zsh configuration (aliases, exports, plugins).
- **`nvim/`**: Neovim configuration (LazyVim setup).
- **`tmux/`**: Tmux configuration and scripts.
- **`ghostty/`**: Ghostty terminal configuration.
- **`git/`**: Git global configuration.
- **`starship.toml`**: Starship prompt configuration.
