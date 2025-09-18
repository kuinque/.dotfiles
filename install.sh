#!/bin/bash

# Dotfiles Installation Script
# Supports macOS, Ubuntu/Debian, Arch Linux, and other Linux distributions

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
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install package manager if not present
install_package_manager() {
    case $OS in
        "macos")
            if ! command_exists brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                source ~/.zprofile
            else
                log_info "Homebrew already installed"
            fi
            ;;
        "debian")
            if ! command_exists apt; then
                log_error "apt not found. Please install it manually."
                exit 1
            fi
            log_info "Updating package list..."
            sudo apt update
            ;;
        "arch")
            if ! command_exists pacman; then
                log_error "pacman not found. Please install it manually."
                exit 1
            fi
            log_info "Updating package list..."
            sudo pacman -Sy
            ;;
        "rhel")
            if ! command_exists dnf && ! command_exists yum; then
                log_error "No supported package manager found (dnf/yum)."
                exit 1
            fi
            ;;
    esac
}

# Install packages based on OS
install_packages() {
    log_info "Installing packages..."
    
    case $OS in
        "macos")
            # Install Homebrew packages
            brew_packages=(
                "kitty"
                "nvim"
                "git"
                "stow"
                "tmux"
                "fzf"
                "zsh"
            )
            
            brew_casks=(
                "font-iosevka"
            )
            
            for package in "${brew_packages[@]}"; do
                if brew list "$package" >/dev/null 2>&1; then
                    log_info "$package already installed"
                else
                    log_info "Installing $package..."
                    brew install "$package"
                fi
            done
            
            for cask in "${brew_casks[@]}"; do
                if brew list --cask "$cask" >/dev/null 2>&1; then
                    log_info "$cask already installed"
                else
                    log_info "Installing $cask..."
                    brew install --cask "$cask"
                fi
            done
            
            # Install macOS-specific tools
            if ! brew list yabai >/dev/null 2>&1; then
                log_info "Installing yabai..."
                brew install koekeishiya/formulae/yabai
            fi
            
            if ! brew list skhd >/dev/null 2>&1; then
                log_info "Installing skhd..."
                brew install koekeishiya/formulae/skhd
            fi
            ;;
            
        "debian")
            packages=(
                "zsh"
                "git"
                "stow"
                "tmux"
                "fzf"
                "neovim"
                "kitty"
                "curl"
                "wget"
            )
            
            for package in "${packages[@]}"; do
                if dpkg -l | grep -q "^ii  $package "; then
                    log_info "$package already installed"
                else
                    log_info "Installing $package..."
                    sudo apt install -y "$package"
                fi
            done
            ;;
            
        "arch")
            packages=(
                "zsh"
                "git"
                "stow"
                "tmux"
                "fzf"
                "neovim"
                "kitty"
                "curl"
                "wget"
            )
            
            for package in "${packages[@]}"; do
                if pacman -Qi "$package" >/dev/null 2>&1; then
                    log_info "$package already installed"
                else
                    log_info "Installing $package..."
                    sudo pacman -S --noconfirm "$package"
                fi
            done
            ;;
            
        "rhel")
            packages=(
                "zsh"
                "git"
                "stow"
                "tmux"
                "fzf"
                "neovim"
                "kitty"
                "curl"
                "wget"
            )
            
            PKG_MGR="dnf"
            if ! command_exists dnf; then
                PKG_MGR="yum"
            fi
            
            for package in "${packages[@]}"; do
                if rpm -q "$package" >/dev/null 2>&1; then
                    log_info "$package already installed"
                else
                    log_info "Installing $package..."
                    sudo $PKG_MGR install -y "$package"
                fi
            done
            ;;
    esac
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    log_info "Installing zsh plugins..."
    
    # Create custom plugins directory
    mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
    
    # Install zsh-autosuggestions
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi
    
    # Install zsh-syntax-highlighting
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi
    
    # Install powerlevel10k
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        log_info "Installing powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
    
    # Install zsh-fzf-history-search
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
        log_info "Installing zsh-fzf-history-search..."
        git clone https://github.com/joshskidmore/zsh-fzf-history-search "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search"
    fi
}

# Install tmux plugins
install_tmux_plugins() {
    log_info "Installing tmux plugins..."
    
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

# Create symlinks for configuration files
create_symlinks() {
    log_info "Creating symlinks for configuration files..."
    
    # Get the directory where this script is located
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Create necessary directories
    mkdir -p "$HOME/.config/yabai"
    mkdir -p "$HOME/.config/skhd"
    
    # Create symlinks
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/.config/yabai/yabairc" "$HOME/.config/yabai/yabairc"
    ln -sf "$DOTFILES_DIR/.config/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
    
    log_success "Symlinks created successfully"
}

# Configure zsh for different platforms
configure_zsh() {
    log_info "Configuring zsh..."
    
    # Backup existing .zshrc if it exists and is not a symlink
    if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
        log_info "Backing up existing .zshrc to .zshrc.backup"
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
    
    # Platform-specific zsh configuration
    case $OS in
        "macos")
            # Add Homebrew paths to .zshrc
            if ! grep -q "homebrew" "$HOME/.zshrc"; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
            fi
            
            # Add Homebrew-specific plugin sources
            if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
                echo 'source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$HOME/.zshrc"
            fi
            
            if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
                echo 'source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"
            fi
            
            if ! grep -q "powerlevel10k" "$HOME/.zshrc"; then
                echo 'source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
            fi
            ;;
        "debian"|"arch"|"rhel")
            # For Linux, we'll use the Oh My Zsh custom directory
            if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
                echo 'source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$HOME/.zshrc"
            fi
            
            if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
                echo 'source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"
            fi
            ;;
    esac
}

# Start services (macOS specific)
start_services() {
    if [[ "$OS" == "macos" ]]; then
        log_info "Starting macOS services..."
        
        # Start skhd service
        if command_exists skhd; then
            skhd --start-service || log_warning "Failed to start skhd service"
        fi
        
        # Note: yabai requires manual setup for accessibility permissions
        log_warning "Note: yabai requires manual setup for accessibility permissions in System Preferences"
    fi
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."
    
    # Check for symlinks-only flag
    if [[ "$1" == "--symlinks-only" ]]; then
        log_info "Creating symlinks only..."
        create_symlinks
        log_success "Symlinks created successfully!"
        return 0
    fi
    
    detect_os
    
    if [[ "$OS" == "unknown" ]]; then
        log_error "Unsupported operating system. Please install manually."
        exit 1
    fi
    
    install_package_manager
    install_packages
    install_oh_my_zsh
    install_zsh_plugins
    install_tmux_plugins
    create_symlinks
    configure_zsh
    start_services
    
    log_success "Installation completed successfully!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
    
    if [[ "$OS" == "macos" ]]; then
        log_warning "Don't forget to:"
        log_warning "1. Grant accessibility permissions to yabai in System Preferences"
        log_warning "2. Run 'p10k configure' to set up your Powerlevel10k theme"
        log_warning "3. Install tmux plugins by pressing Ctrl+a then I in tmux"
    fi
}

# Run main function
main "$@"
