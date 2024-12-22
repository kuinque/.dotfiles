# .dotfiles
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

source ~/.zprofile

brew install kitty

brew install nvim

brew install git

brew install --cask font-iosevka

brew install powerlevel10k

echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

brew install oh-my-zsh

brew install stow

stow . symlinks dotfiles

brew install zsh-autosuggestions

echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

brew install zsh-syntax-highlighting

echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

brew install tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

source ~/.zshrc

brew install koekeishiya/formulae/skhd

brew install koekeishiya/formulae/yabai
 
skhd --start-service
