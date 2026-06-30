# Dotfiles Makefile
# Provides convenient shortcuts for common dotfiles operations

.PHONY: help install update check symlinks clean status

# Default target
help:
	@echo "Dotfiles Management"
	@echo "=================="
	@echo ""
	@echo "Available targets:"
	@echo "  install    - Install dotfiles and all dependencies"
	@echo "  update     - Update all packages and configurations"
	@echo "  check      - Check system status and installed components"
	@echo "  symlinks   - Create only symbolic links (no package installation)"
	@echo "  clean      - Remove symlinks and restore original files"
	@echo "  status     - Show current system status"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make install    # Full installation"
	@echo "  make update     # Update everything"
	@echo "  make check      # Check system status"

# Install dotfiles
install:
	@./dotfiles.sh install

# Update dotfiles
update:
	@./dotfiles.sh update

# Check system
check:
	@./dotfiles.sh check

# Create symlinks only
symlinks:
	@./dotfiles.sh symlinks

# Show status
status: check

# Clean symlinks (unstow the home package)
clean:
	@echo "Removing symlinks..."
	@stow --dir="$(CURDIR)" --target="$(HOME)" --delete home
	@echo "Symlinks removed. Any *.backup files are preserved."
