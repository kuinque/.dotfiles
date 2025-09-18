#!/bin/bash

# Dotfiles Management Script
# Central script for managing dotfiles installation, updates, and checks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

log_header() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

# Show help
show_help() {
    echo -e "${PURPLE}Dotfiles Management Script${NC}"
    echo
    echo "Usage: $0 [COMMAND]"
    echo
    echo "Commands:"
    echo "  install     Install dotfiles and all dependencies"
    echo "  update      Update all packages and configurations"
    echo "  check       Check system status and installed components"
    echo "  symlinks    Create only symbolic links (no package installation)"
    echo "  help        Show this help message"
    echo
    echo "Examples:"
    echo "  $0 install          # Full installation"
    echo "  $0 update           # Update everything"
    echo "  $0 check            # Check system status"
    echo "  $0 symlinks         # Create symlinks only"
    echo
}

# Install dotfiles
install_dotfiles() {
    log_header "Installing Dotfiles"
    "$SCRIPT_DIR/install.sh"
}

# Update dotfiles
update_dotfiles() {
    log_header "Updating Dotfiles"
    "$SCRIPT_DIR/update.sh"
}

# Check system
check_system() {
    log_header "Checking System"
    "$SCRIPT_DIR/check.sh"
}

# Create symlinks only
create_symlinks() {
    log_header "Creating Symlinks Only"
    "$SCRIPT_DIR/install.sh" --symlinks-only
}

# Main function
main() {
    case "${1:-help}" in
        "install")
            install_dotfiles
            ;;
        "update")
            update_dotfiles
            ;;
        "check")
            check_system
            ;;
        "symlinks")
            create_symlinks
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            echo
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
