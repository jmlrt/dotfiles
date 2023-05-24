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
    cd $SPOONS_HOME
    wget https://github.com/Hammerspoon/Spoons/raw/master/Spoons/$spoon.spoon.zip
    unzip $spoon.spoon.zip
    rm $spoon.spoon.zip
}

symlink aliases.zsh ~/.aliases.zsh
symlink config/gh/config.yml ~/.config/gh/config.yml
symlink config/nvim/init.vim ~/.config/nvim/init.vim
symlink docker/daemon.json ~/.docker/daemon.json
symlink gitconfig ~/.gitconfig
symlink gitignore_global ~/.gitignore_global
symlink gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
symlink hammerspoon/init.lua ~/.hammerspoon/init.lua
symlink ssh/config ~/.ssh/config
symlink tmux.conf ~/.tmux.conf
symlink zprofile ~/.zprofile
symlink zshrc ~/.zshrc

install_spoon Caffeine
install_spoon Cherry
install_spoon ReloadConfiguration
install_spoon WindowHalfsAndThirds
install_spoon WindowScreenLeftAndRight
