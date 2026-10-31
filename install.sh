#!/usr/bin/env bash

DOTFILES_HOME=$(cd "$(dirname "$0")" && pwd)

function symlink() {
    src=$DOTFILES_HOME/$1
    dst=$2
    dst_dir=$(dirname "$dst")
    mkdir -p "$dst_dir"
    ln -nsf "$src" "$dst" && echo "File $src linked to $dst"
}

symlink config/clipmd/config.yaml ~/.config/clipmd/config.yaml
symlink config/git/ignore ~/.config/git/ignore
symlink config/ghostty/config ~/.config/ghostty/config
symlink config/vim/vimrc ~/.vimrc
symlink config/git/config ~/.config/git/config
symlink config/markdownlint/markdownlint.yaml ~/.config/markdownlint/markdownlint.yaml
symlink gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
symlink ssh/config ~/.ssh/config
mkdir -p ~/.ssh/sockets
symlink config/tmux/tmux.conf ~/.config/tmux/tmux.conf
symlink config/vscode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
# Vibe saves its config with an atomic rename, which replaces a symlink with a
# regular file — so this one is copied, not symlinked. To persist Vibe-side
# changes (permissions clicked as "always allow", settings edits), copy
# ~/.vibe/config.toml back into the repo before committing.
mkdir -p ~/.vibe
cp config/vibe/config.toml ~/.vibe/config.toml && echo "File $DOTFILES_HOME/config/vibe/config.toml copied to ~/.vibe/config.toml"
symlink zshrc ~/.zshrc
