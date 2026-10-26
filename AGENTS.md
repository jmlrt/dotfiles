# AGENTS.md

## Constraints

- Personal dotfiles for macOS, Apple Silicon only. Homebrew is at `/opt/homebrew`; Intel paths are intentionally unsupported.
- Prefer OS-shipped tools over brew duplicates (macOS ships `jq`).
- This repository is public: never stage or commit GPG key material, exported keys, or any other secrets. `detect-private-key` runs as a pre-commit hook.

## Layout

- `install.sh` creates the symlinks into `~` and is the source of truth for the file mapping. It force-replaces destinations (`ln -nsf`), including regular files in the way.
- Configs are symlinked, so edits take effect immediately — do not re-run `install.sh` to apply a change.

## Where things go

- `zshrc` — environment, interactive setup, all aliases and functions.
- Untracked, sourced if present: `~/.personal.zsh` (per-machine extras), `~/.elastic.zsh` (work laptop only). `~/.zprofile` stays a local file (installers append to it).
- Per-machine settings stay out of this repo (ex: `~/.config/git/config.local`).

## Commits and verification

- Commits and tags are GPG-signed by default; the signing key is per machine (`user.signingkey` in `~/.config/git/config.local`). Key migration commands: `README.md`.
- No test suite. Verify shell edits with `zsh -n` / `shellcheck`; whitespace and secret-detection hooks run via `pre-commit`.
