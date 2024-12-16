#!/usr/bin/env bash

DOTFILES_HOME=$(cd "$(dirname "$0")" && pwd)

function symlink() {
    src=$DOTFILES_HOME/$1
    dst=$2
    dst_dir=$(dirname $dst)
    mkdir -p $dst_dir
    ln -nsf "$src" "$dst" && echo "File $src linked to $dst"
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
