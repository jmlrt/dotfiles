# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS. Configuration files are version-controlled here and symlinked to their expected locations in `~` via `install.sh`.

## Installation

```bash
./install.sh
```

This creates symlinks (e.g. `~/.zshrc -> dotfiles/zshrc`). Add `--install-spoons` to also download the Hammerspoon Spoons from GitHub.

To install Homebrew packages:
```bash
brew bundle --file Brewfile
```

## Architecture

### Symlink mapping

`install.sh` maps repo files to their home directory destinations. When editing a config file, the symlink means changes take effect immediately without re-running install.

Key mappings:
- `zshrc` → `~/.zshrc`
- `aliases.zsh` → `~/.aliases.zsh`
- `config/git/config` → `~/.config/git/config`
- `config/nvim/init.vim` → `~/.config/nvim/init.vim`
- `hammerspoon/init.lua` → `~/.hammerspoon/init.lua`
- `ssh/config` → `~/.ssh/config`

### Shell configuration split

- `zshrc` — shell init, PATH, Oh-My-Zsh, tool integrations
- `aliases.zsh` — all aliases and functions (git, kubectl, fzf utilities, englog)
- `~/.elastic.zsh`, `~/.personal.zsh` — sourced if present; not tracked here (work/personal overrides)
- **No `git config --global` in shell startup**: parallel terminals or a stale lock give "could not lock config
  file". Write to `~/.config/git/config.local` with a write-once guard
  (`[ "$(git config --file ~/.config/git/config.local key 2>/dev/null)" = "value" ] || git config --file
  ~/.config/git/config.local key value`) and `[include] path = ~/.config/git/config.local` in the tracked config.

### GPG signing

Git commits and tags are signed by default. The signing key differs per machine, so it is not tracked: set
`user.signingkey` in `~/.config/git/config.local` (the work overlay writes it). `gnupg/gpg-agent.conf` calls
`gnupg/pinentry-wrapper.sh`, which runs `pinentry-mac` from `PATH` (gpg-agent doesn't expand `$HOMEBREW_PREFIX`).

### Multi-arch Homebrew

`zshrc` detects Intel vs Apple Silicon and sets `HOMEBREW_PREFIX` accordingly (`/usr/local` vs `/opt/homebrew`).
