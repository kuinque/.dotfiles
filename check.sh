#!/bin/bash

# Dotfiles System Check Script
# Checks if all required tools and configurations are properly installed

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
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if file exists and is a symlink
is_symlink() {
    [[ -L "$1" ]]
}

# Check if file exists
file_exists() {
    [[ -f "$1" ]]
}

# Check if directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Check basic tools
check_basic_tools() {
    log_info "Checking basic tools..."
    
    local tools=("zsh" "git" "tmux" "nvim" "fzf")
    local all_good=true
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool is installed"
        else
            log_error "$tool is not installed"
            all_good=false
        fi
    done
    
    if [[ "$all_good" == true ]]; then
        log_success "All basic tools are installed"
    else
        log_warning "Some basic tools are missing"
    fi
}

# Check Oh My Zsh
check_oh_my_zsh() {
    log_info "Checking Oh My Zsh..."
    
    if dir_exists "$HOME/.oh-my-zsh"; then
        log_success "Oh My Zsh is installed"
    else
        log_error "Oh My Zsh is not installed"
        return 1
    fi
}

# Check zsh plugins
check_zsh_plugins() {
    log_info "Checking zsh plugins..."
    
    local plugins=(
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "powerlevel10k"
        "zsh-fzf-history-search"
    )
    
    local all_good=true
    
    for plugin in "${plugins[@]}"; do
        if [[ "$plugin" == "powerlevel10k" ]]; then
            if dir_exists "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$plugin"; then
                log_success "$plugin theme is installed"
            else
                log_error "$plugin theme is not installed"
                all_good=false
            fi
        else
            if dir_exists "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"; then
                log_success "$plugin plugin is installed"
            else
                log_error "$plugin plugin is not installed"
                all_good=false
            fi
        fi
    done
    
    if [[ "$all_good" == true ]]; then
        log_success "All zsh plugins are installed"
    else
        log_warning "Some zsh plugins are missing"
    fi
}

# Check tmux plugins
check_tmux_plugins() {
    log_info "Checking tmux plugins..."
    
    if dir_exists "$HOME/.tmux/plugins/tpm"; then
        log_success "tmux plugin manager (tpm) is installed"
    else
        log_error "tmux plugin manager (tpm) is not installed"
    fi
}

# Check configuration files
check_config_files() {
    log_info "Checking configuration files..."
    
    local configs=(
        "$HOME/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
    )
    
    local all_good=true
    
    for config in "${configs[@]}"; do
        if file_exists "$config"; then
            if is_symlink "$config"; then
                log_success "$(basename "$config") is properly symlinked"
            else
                log_warning "$(basename "$config") exists but is not a symlink"
            fi
        else
            log_error "$(basename "$config") is missing"
            all_good=false
        fi
    done
    
    if [[ "$all_good" == true ]]; then
        log_success "All configuration files are present"
    else
        log_warning "Some configuration files are missing"
    fi
}

# Check macOS specific tools
check_macos_tools() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Checking macOS specific tools..."
        
        local tools=("yabai" "skhd" "brew")
        local all_good=true
        
        for tool in "${tools[@]}"; do
            if command_exists "$tool"; then
                log_success "$tool is installed"
            else
                log_error "$tool is not installed"
                all_good=false
            fi
        done
        
        if [[ "$all_good" == true ]]; then
            log_success "All macOS tools are installed"
        else
            log_warning "Some macOS tools are missing"
        fi
    fi
}

# Check package manager
check_package_manager() {
    log_info "Checking package manager..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists brew; then
            log_success "Homebrew is installed"
        else
            log_error "Homebrew is not installed"
        fi
    elif [[ -f /etc/debian_version ]]; then
        if command_exists apt; then
            log_success "apt is available"
        else
            log_error "apt is not available"
        fi
    elif [[ -f /etc/arch-release ]]; then
        if command_exists pacman; then
            log_success "pacman is available"
        else
            log_error "pacman is not available"
        fi
    elif [[ -f /etc/redhat-release ]]; then
        if command_exists dnf || command_exists yum; then
            log_success "Package manager is available"
        else
            log_error "No package manager found"
        fi
    fi
}

# Check shell
check_shell() {
    log_info "Checking shell configuration..."
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_success "zsh is the current shell"
    else
        log_warning "Current shell is $SHELL, zsh is recommended"
    fi
}

# Main check function
main() {
    log_info "Starting dotfiles system check..."
    echo
    
    check_basic_tools
    echo
    
    check_package_manager
    echo
    
    check_shell
    echo
    
    check_oh_my_zsh
    echo
    
    check_zsh_plugins
    echo
    
    check_tmux_plugins
    echo
    
    check_config_files
    echo
    
    check_macos_tools
    echo
    
    log_info "System check completed!"
    log_info "If you see any errors above, run './install.sh' to fix them."
}

# Run main function
main "$@"
