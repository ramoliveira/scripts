#!/bin/bash

SOURCE=""

if [ -f ~/.bashrc ]; then
  echo "Installing on .bashrc"
  SOURCE=$HOME/.bashrc
elif [ -f ~/.zshrc ]; then
  echo "Installing on .zshrc"
  SOURCE=$HOME/.zshrc
fi

SOURCE_BACKUP=$SOURCE.bak

backup_source() {
  echo "💾 Backing up $SOURCE"
  cp "$SOURCE" "$SOURCE_BACKUP"
}

restore_source() {
  echo "🔄 Restoring $SOURCE"
  cp "$SOURCE_BACKUP" "$SOURCE"
}

removing_source_backup() {
  echo "🗑️ Removing $SOURCE_BACKUP"
  rm "$SOURCE_BACKUP"
}

backup_source()

if [ uname -eq "Darwin" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  xcode-select --install
  brew update
  brew upgrade
  brew install tldr
  brew install pidof
  brew install nvim
  brew install --cask font-hack-nerd-font
  brew install tree-sitter
  brew install luajit
  brew install python

  BREW_PATH='export PATH="/opt/homebrew/bin:$PATH"'
  if ! grep -qF "$BREW_PATH" "$SOURCE_BACKUP"; then
    printf "%s\n%s\n" "$BREW_PATH" "$(cat "$SOURCE_BACKUP")" > "$SOURCE_BACKUP"
  fi
else
  apt update
  apt upgrade
  apt install xclip
  echo 'alias pbcopy="xclip -selection clipboard"' >> $SOURCE_BACKUP
  echo 'alias pbpaste="xclip -selection clipboard -o"' >> $SOURCE_BACKUP
  apt install tldr
  apt install pidof
  apt install nvim
  apt install curl

  curl -sSLo nerdfonts-installer https://github.com/fam007e/nerd_fonts_installer/releases/latest/download/nerdfonts-installer && chmod +x nerdfonts-installer && ./nerdfonts-installer
  rm nerdfonts-installer
fi

curl https://raw.githubusercontent.com/ramoliveira/scripts/refs/heads/main/init.lua --create-dirs -o ~/.config/nvim/init.lua

restore_source()
removing_source_backup()
