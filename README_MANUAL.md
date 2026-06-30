# Ручная установка (macOS)

Шпаргалка на случай, если не хочется запускать `./install.sh`.
Конфиги раскладываются через `stow` из пакета `home/`, поэтому в `~/.zshrc`
ничего дописывать вручную НЕ нужно — плагины подключает oh-my-zsh через массив
`plugins=(...)`, а тему задаёт `ZSH_THEME`.

```bash
# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc.local   # машинно-специфично, не в git

# 2. Пакеты
brew install git stow tmux fzf zsh neovim kitty
brew install --cask font-iosevka
brew install koekeishiya/formulae/skhd koekeishiya/formulae/yabai

# 3. oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. Плагины и тема zsh (в $ZSH_CUSTOM, подключаются через plugins=() и ZSH_THEME)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/joshskidmore/zsh-fzf-history-search "$ZSH_CUSTOM/plugins/zsh-fzf-history-search"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# 5. tmux plugin manager (остальные плагины поставит TPM по Ctrl+a I)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 6. Симлинки конфигов
cd ~/.dotfiles
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow home

# 7. Запуск сервисов и финал
skhd --start-service
source ~/.zshrc
```
