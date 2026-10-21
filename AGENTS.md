# AGENTS.md

This file provides guidance to AI coding agents (Mistral Vibe, Claude Code) when working with code in this repository.

## Overview

Personal dotfiles for macOS. Configuration files are version-controlled here and symlinked to their expected locations in `~` via `install.sh`.

## Machines

These dotfiles target Apple Silicon Macs only:

- Personal: MacBook Pro M3 (2023) — the bootstrap target
- Work: Apple Silicon (M5, 2026) — work specifics live only in untracked `~/.elastic.zsh`

Homebrew lives at `/opt/homebrew` on both; Intel paths are intentionally not supported (a retired Intel MacBook Pro was the original source of this config). Prefer OS-shipped tools over brew duplicates (macOS has shipped `jq` since Sequoia).

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

`install.sh` maps repo files to their home directory destinations. When editing a config file, the symlink means changes take effect immediately without re-running install. Note: `ln -nsf` force-replaces destinations, including regular files in the way.

Key mappings:
- `zshrc` → `~/.zshrc`
- `aliases.zsh` → `~/.aliases.zsh`
- `config/git/config` → `~/.config/git/config`
- `config/git/ignore` → `~/.config/git/ignore` (used by git as the global excludes file via XDG)
- `config/nvim/init.vim` → `~/.config/nvim/init.vim`
- `hammerspoon/init.lua` → `~/.hammerspoon/init.lua`
- `ssh/config` → `~/.ssh/config`

### Shell configuration split

- `zshrc` — shell init, PATH, Oh-My-Zsh (which also provides history defaults), tool integrations
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

### Multi-arch Homebrew

`zshrc` detects Intel vs Apple Silicon and sets `HOMEBREW_PREFIX` accordingly (`/usr/local` vs `/opt/homebrew`).
