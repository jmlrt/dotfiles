# AGENTS.md

This file provides guidance to AI coding agents (Mistral Vibe) when working with code in this repository.

## Overview

Personal dotfiles for macOS. Configuration files are version-controlled here and symlinked to their expected locations in `~` via `install.sh`.

## Machines

These dotfiles target Apple Silicon Macs only:

- Personal: MacBook Pro M2 Pro (Mac14,9) — the bootstrap target
- Work: Apple Silicon (M5, 2026) — work specifics live only in untracked `~/.elastic.zsh`

Homebrew lives at `/opt/homebrew` on both; Intel paths are intentionally not supported (a retired Intel MacBook Pro was the original source of this config). Prefer OS-shipped tools over brew duplicates (macOS has shipped `jq` since Sequoia).

## Installation

```bash
./install.sh
```

This creates symlinks (e.g. `~/.zshrc -> dotfiles/zshrc`).

To install Homebrew packages, uv tools, and App Store apps (via `mas`; requires being signed in to the App Store):
```bash
brew bundle --file Brewfile
```

The uv-managed CLI agent is the PyPI package `mistral-vibe`. Do not `uv tool install vibe`: that is an unrelated, source-only package whose build pulls in a Rust toolchain.

## Architecture

### Symlink mapping

`install.sh` maps repo files to their home directory destinations. When editing a config file, the symlink means changes take effect immediately without re-running install. Note: `ln -nsf` force-replaces destinations, including regular files in the way.

Key mappings:
- `zshrc` → `~/.zshrc`
- `aliases.zsh` → `~/.aliases.zsh`
- `config/git/config` → `~/.config/git/config`
- `config/git/ignore` → `~/.config/git/ignore` (used by git as the global excludes file via XDG)
- `config/vim/vimrc` → `~/.vimrc` (macOS-shipped Vim 9.1; neovim was dropped)
- `ssh/config` → `~/.ssh/config`
- `zprofile` → `~/.zprofile` (Obsidian CLI PATH)

### Shell configuration split

- `zshrc` — shell init, PATH, history and completion (no framework; oh-my-zsh was dropped), tool integrations
- `aliases.zsh` — all aliases and functions (git, fzf utilities)
- `~/.personal.zsh` — sourced if present; not tracked here (per-machine local extras)
- `~/.elastic.zsh` — sourced if present; not tracked here (work-machine specifics; the file only exists on the work laptop)
- **No `git config --global` in shell startup**: parallel terminals or a stale lock give "could not lock config
  file". Write to `~/.config/git/config.local` with a write-once guard
  (`[ "$(git config --file ~/.config/git/config.local key 2>/dev/null)" = "value" ] || git config --file
  ~/.config/git/config.local key value`) and `[include] path = ~/.config/git/config.local` in the tracked config.

### GPG signing

Git commits and tags are signed by default. The signing key differs per machine, so it is not tracked: set
`user.signingkey` in `~/.config/git/config.local`. `gnupg/gpg-agent.conf` calls
`gnupg/pinentry-wrapper.sh`, which runs `pinentry-mac` from `PATH` (gpg-agent doesn't expand `$HOMEBREW_PREFIX`).
