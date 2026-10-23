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
symlink config/clipmd/config.yaml ~/.config/clipmd/config.yaml
symlink config/git/ignore ~/.config/git/ignore
symlink config/ghostty/config ~/.config/ghostty/config
symlink config/nvim/init.vim ~/.config/nvim/init.vim
symlink config/git/config ~/.config/git/config
symlink config/markdownlint/markdownlint.yaml ~/.config/markdownlint/markdownlint.yaml
symlink gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
symlink gnupg/pinentry-wrapper.sh ~/.gnupg/pinentry-wrapper.sh
chmod +x "$DOTFILES_HOME/gnupg/pinentry-wrapper.sh"
symlink ssh/config ~/.ssh/config
mkdir -p ~/.ssh/sockets
symlink config/tmux/tmux.conf ~/.config/tmux/tmux.conf
symlink zprofile ~/.zprofile
symlink zshrc ~/.zshrc
