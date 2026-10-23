# Dotfiles

Personal dotfiles for macOS. Files are version-controlled here and symlinked into place by `install.sh`.

## Bootstrap a new machine

```bash
# 1. Install Homebrew (https://brew.sh), clone this repo, then packages
#    (also installs uv tools and App Store apps via mas — sign in to the App Store first)
brew bundle --file Brewfile

# 2. Symlink configs (force-replaces anything already at the destinations)
./install.sh

# 3. Per-machine git config (the signing key is deliberately not tracked)
mkdir -p ~/.config/git
cat > ~/.config/git/config.local <<'EOF'
[user]
	signingkey = <YOUR-KEY-ID>
EOF
```

`bw-backup` and `spotfm` are personal tools that are not on PyPI, so `brew bundle` cannot install them; they are listed in the Brewfile only so that `brew bundle check`/`cleanup` recognize them. First install:

```bash
uv tool install "git+ssh://git@github.com/jmlrt/toolbox.git#subdirectory=bw-backup"
uv tool install --editable ~/Code/spotfm
```

## Notes

- Window tiling and keep-awake are native: bind shortcuts to the Window > Move & Resize menu items (System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts), and use the `coffee`/`decaf` aliases (caffeinate) instead of Hammerspoon.
- `~/.personal.zsh` is sourced by `zshrc` if present; use it for untracked, per-machine shell extras. On the work machine, `~/.elastic.zsh` plays the same role.
- Git commits and tags are signed by default (`config/git/config`); without step 3 the first commit will fail if gpg has no default key.
- Migrate GPG signing keys manually: `gpg --export-secret-keys <KEY-ID> > key.gpg` on the old machine, then `gpg --import key.gpg` on the new one.
- Pre-commit hooks (`.pre-commit-config.yaml`) run once `pre-commit install` has been executed in the repo.
