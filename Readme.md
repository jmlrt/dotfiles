# Dotfiles

Personal dotfiles for macOS. Files are version-controlled here and symlinked into place by `install.sh`.

## Bootstrap a new machine

```bash
# 0. Clone the personal repos (uv tools and agent skills live there)
gh repo clone jmlrt/dotfiles ~/Code/dotfiles
gh repo clone jmlrt/toolbox ~/Code/toolbox
gh repo clone jmlrt/spotfm ~/Code/spotfm
gh repo clone jmlrt/skills ~/Code/skills

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
- `~/.personal.zsh` is sourced by `zshrc` if present; use it for untracked, per-machine shell extras. On the work machine, `~/.elastic.zsh` plays the same role. Example for the Bitwarden SSH agent: `export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"`.
- Agent skills: Mistral Vibe loads user skills from `~/.vibe/skills` and `~/.agents/skills` (the latter is also the Codex path), so symlink selected folders from `~/Code/skills` — e.g. `ln -ns ~/Code/skills/git ~/.vibe/skills/git`. Keep only the skills you use; their descriptions are always loaded, so a smaller set matches better.
- Git commits and tags are signed by default (`config/git/config`); without step 3 the first commit will fail if gpg has no default key.
- Migrate the GPG signing key manually (commands only here — never commit the exported key material to any repo):

```bash
# old machine: export ASCII-armored (safe to move via any text channel, e.g. clipboard)
gpg --armor --export-secret-keys <KEYID> | pbcopy

# new machine: import, set ultimate trust, and point git at it
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg   # 700, not 600: without the execute bit gpg cannot read the directory
pbpaste | gpg --import
echo <KEYID>:6 | gpg --import-ownertrust
git config --file ~/.config/git/config.local user.signingkey <KEYID>
gpgconf --kill gpg-agent   # pick up the new gpg-agent.conf / pinentry

# verify, then delete the key material from wherever you staged it
echo test | gpg --clearsign > /dev/null && echo "signing OK"
```

  Renew before expiry (a reminder beats a surprise on the next commit): `gpg --quick-set-expire <KEYID> 2y`.
- The repo's pre-commit hooks include `detect-private-key`, which blocks accidental commits of private key material (including OpenPGP blocks); run `pre-commit install` once per clone so they are active.
- Pre-commit hooks (`.pre-commit-config.yaml`) run once `pre-commit install` has been executed in the repo.
