#!/bin/bash

# Dotfiles Update Script
# Updates packages and configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
    elif [[ -f /etc/redhat-release ]]; then
        OS="rhel"
    else
        OS="unknown"
    fi
}

# Update packages
update_packages() {
    log_info "Updating packages..."
    
    case $OS in
        "macos")
            if command -v brew >/dev/null 2>&1; then
                brew update
                brew upgrade
            fi
            ;;
        "debian")
            sudo apt update
            sudo apt upgrade -y
            ;;
        "arch")
            sudo pacman -Syu --noconfirm
            ;;
        "rhel")
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf update -y
            elif command -v yum >/dev/null 2>&1; then
                sudo yum update -y
            fi
            ;;
    esac
}

# Update Oh My Zsh
update_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Updating Oh My Zsh..."
        cd "$HOME/.oh-my-zsh"
        git pull
    fi
}

# Update zsh plugins
update_zsh_plugins() {
    log_info "Updating zsh plugins..."
    
    # Update zsh-autosuggestions
    if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        git pull
    fi
    
    # Update zsh-syntax-highlighting
    if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
        git pull
    fi
    
    # Update powerlevel10k
    if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        git pull
    fi
    
    # Update zsh-fzf-history-search
    if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
        cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search"
        git pull
    fi
}

# Update tmux plugins
update_tmux_plugins() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Updating tmux plugins..."
        cd "$HOME/.tmux/plugins/tpm"
        git pull
    fi
}

# Update dotfiles repository
update_dotfiles() {
    log_info "Updating dotfiles repository..."
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$DOTFILES_DIR"
    git pull
}

# Main update function
main() {
    log_info "Starting dotfiles update..."
    
    detect_os
    
    if [[ "$OS" == "unknown" ]]; then
        log_error "Unsupported operating system."
        exit 1
    fi
    
    update_packages
    update_oh_my_zsh
    update_zsh_plugins
    update_tmux_plugins
    update_dotfiles
    
    log_success "Update completed successfully!"
    log_info "Please restart your terminal to apply any changes."
}

# Run main function
main "$@"
