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
symlink zshrc ~/.zshrc

# Shared skills from jmlrt/skills, for Codex/agents and Claude Code
mkdir -p ~/.agents/skills ~/.claude/skills
for skill in ~/Code/jmlrt/skills/*/SKILL.md; do
    skill=$(basename "$(dirname "$skill")")
    ln -nsf ~/Code/jmlrt/skills/"$skill" ~/.agents/skills/"$skill"
    ln -nsf ~/.agents/skills/"$skill" ~/.claude/skills/"$skill"
    echo "Skill $skill linked"
done
