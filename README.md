# .dotfiles

Универсальная конфигурация для разработки с поддержкой macOS, Ubuntu/Debian, Arch Linux и других Linux дистрибутивов.

inspired by https://missing.csail.mit.edu/

## 🚀 Быстрый старт

### Автоматическая установка

```bash
# Клонируйте репозиторий
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Запустите скрипт установки
./install.sh
```

### Ручная установка

Если вы предпочитаете ручную установку, следуйте инструкциям ниже для вашей операционной системы.

## 📦 Что устанавливается

### Основные инструменты
- **zsh** с Oh My Zsh
- **Powerlevel10k** - красивая тема для zsh
- **Neovim** - современный редактор
- **tmux** - терминальный мультиплексор
- **fzf** - нечеткий поиск
- **git** - система контроля версий
- **kitty** - современный терминал

### Плагины zsh
- `zsh-autosuggestions` - автодополнение команд
- `zsh-syntax-highlighting` - подсветка синтаксиса
- `zsh-fzf-history-search` - поиск по истории с fzf

### Плагины tmux
- `tpm` - менеджер плагинов tmux
- `vim-tmux-navigator` - навигация между vim и tmux
- `tmux-resurrect` - восстановление сессий
- `tmux-continuum` - автоматическое сохранение

### macOS-специфичные инструменты
- **yabai** - тайловый оконный менеджер
- **skhd** - демон горячих клавиш
- **Homebrew** - пакетный менеджер

## 🖥️ Поддерживаемые платформы

### macOS
- Автоматическая установка через Homebrew
- Поддержка yabai и skhd
- Настройка для Apple Silicon и Intel

### Ubuntu/Debian
- Установка через apt
- Автоматическое обновление пакетов

### Arch Linux
- Установка через pacman
- Поддержка AUR (при необходимости)

### RHEL/Fedora
- Установка через dnf/yum
- Совместимость с CentOS, Rocky Linux

## 📁 Структура конфигураций

Все пользовательские конфиги лежат в каталоге-пакете `home/`, который точно
повторяет структуру `$HOME`. Симлинки в домашнюю директорию раскладываются
через [GNU stow](https://www.gnu.org/software/stow/) одной командой.

```
.dotfiles/
├── home/                     # stow-пакет (раскладывается в $HOME)
│   ├── .zshrc                # Конфигурация zsh
│   ├── .tmux.conf            # Конфигурация tmux
│   ├── .gitconfig            # Конфигурация git
│   ├── .p10k.zsh             # Тема Powerlevel10k
│   └── .config/
│       ├── kitty/            # Конфигурация kitty
│       ├── nvim/             # Конфигурация Neovim
│       ├── yabai/yabairc     # Конфигурация yabai (macOS)
│       └── skhd/skhdrc       # Конфигурация skhd (macOS)
├── install.sh                # Скрипт установки
├── update.sh                 # Скрипт обновления
└── Makefile                  # make install / update / check / clean
```

> Машинно-специфичные настройки (PATH, `brew shellenv` и т.п.) живут в
> `~/.zshrc.local` — этот файл не отслеживается git и подключается из `.zshrc`.
> Ручное редактирование симлинков не нужно: правьте файлы прямо в `home/`.

## 🔧 Управление

### Обновление
```bash
./update.sh
```

### Переустановка
```bash
./install.sh
```

### Создание символических ссылок (если нужно)
```bash
# Создать только симлинки без установки пакетов
./install.sh --symlinks-only
```

## ⚙️ Настройка после установки

### macOS
1. Предоставьте разрешения на доступность для yabai в Системных настройках
2. Настройте Powerlevel10k: `p10k configure`
3. Установите плагины tmux: нажмите `Ctrl+a` затем `I` в tmux

### Linux
1. Установите zsh как оболочку по умолчанию: `chsh -s $(which zsh)`
2. Настройте Powerlevel10k: `p10k configure`
3. Установите плагины tmux: нажмите `Ctrl+a` затем `I` в tmux

## 🎨 Кастомизация

### Изменение темы tmux
Отредактируйте `.tmux.conf` и измените строку:
```bash
set -g @themepack 'powerline/block/blue'
```

### Настройка горячих клавиш yabai
Отредактируйте `home/.config/skhd/skhdrc` для изменения горячих клавиш.

### Добавление новых плагинов zsh
Добавьте плагины в массив `plugins` в `.zshrc`:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search zsh-fzf-history-search your-new-plugin)
```

## 🐛 Устранение неполадок

### Проблемы с символическими ссылками
```bash
# Пересоздать все симлинки через stow (идемпотентно)
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow home

# Либо удалить и создать заново
make clean && ./install.sh --symlinks-only
```
Если stow жалуется на конфликт, значит в `$HOME` уже лежит настоящий файл —
переименуйте его (installer делает `*.backup` автоматически) и повторите.

### Проблемы с правами доступа
```bash
# Убедитесь, что скрипты исполняемые
chmod +x install.sh update.sh
```

### Проблемы с Homebrew на macOS
```bash
# Переустановить Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 📝 Лицензия

MIT License - используйте свободно!

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции
3. Внесите изменения
4. Создайте Pull Request

## 📞 Поддержка

Если у вас возникли проблемы или вопросы, создайте Issue в репозитории.

