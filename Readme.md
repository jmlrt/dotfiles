# Dotfiles

Personal dotfiles for macOS. Files are version-controlled here and symlinked into place by `install.sh`.

## Bootstrap a new machine

```bash
# 1. Install Homebrew (https://brew.sh), clone this repo, then packages
brew bundle --file Brewfile

# 2. Oh My Zsh (zshrc loads it from ~/.oh-my-zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 3. Symlink configs (force-replaces anything already at the destinations)
./install.sh

# 4. Per-machine git config (the signing key is deliberately not tracked)
mkdir -p ~/.config/git
cat > ~/.config/git/config.local <<'EOF'
[user]
	signingkey = <YOUR-KEY-ID>
EOF
```

## Notes

- `install.sh --install-spoons` also downloads the Hammerspoon Spoons.
- `~/.personal.zsh` is sourced by `zshrc` if present; use it for untracked, per-machine shell extras. On the work machine, `~/.elastic.zsh` plays the same role.
- Git commits and tags are signed by default (`config/git/config`); without step 4 the first commit will fail if gpg has no default key.
- Migrate GPG signing keys manually: `gpg --export-secret-keys <KEY-ID> > key.gpg` on the old machine, then `gpg --import key.gpg` on the new one.
- Pre-commit hooks (`.pre-commit-config.yaml`) run once `pre-commit install` has been executed in the repo.
