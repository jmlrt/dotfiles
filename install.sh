#!/usr/bin/env bash

DOTFILES_HOME=$(cd "$(dirname "$0")" && pwd)
SPOONS_HOME=~/.hammerspoon/Spoons

function symlink() {
    src=$DOTFILES_HOME/$1
    dst=$2
    dst_dir=$(dirname $dst)
    mkdir -p $dst_dir
    ln -nsf "$src" "$dst" && echo "File $src linked to $dst"
}

function install_spoon() {
    spoon=$1
    mkdir -p $SPOONS_HOME
    curl -Lo "$SPOONS_HOME/$spoon.spoon.zip" https://github.com/Hammerspoon/Spoons/raw/master/Spoons/$spoon.spoon.zip
    unzip -o "$SPOONS_HOME/$spoon.spoon.zip" -d "$SPOONS_HOME"
    rm "$SPOONS_HOME/$spoon.spoon.zip"
}

symlink aliases.zsh ~/.aliases.zsh
symlink config/clipmd/config.yaml ~/.config/clipmd/config.yaml
symlink config/git/ignore ~/.config/git/ignore
symlink config/ghostty/config ~/.config/ghostty/config
symlink config/nvim/init.vim ~/.config/nvim/init.vim
symlink config/git/config ~/.config/git/config
symlink config/markdownlint/markdownlint.yaml ~/.config/markdownlint/markdownlint.yaml
symlink gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
symlink gnupg/pinentry-wrapper.sh ~/.gnupg/pinentry-wrapper.sh
chmod +x "$DOTFILES_HOME/gnupg/pinentry-wrapper.sh"
symlink hammerspoon/init.lua ~/.hammerspoon/init.lua
symlink ssh/config ~/.ssh/config
mkdir -p ~/.ssh/sockets
symlink config/tmux/tmux.conf ~/.config/tmux/tmux.conf
symlink zshrc ~/.zshrc

if [ "$1" = "--install-spoons" ]; then
    for spoon in Caffeine Cherry ReloadConfiguration WindowHalfsAndThirds WindowScreenLeftAndRight; do
        install_spoon $spoon
    done
fi
