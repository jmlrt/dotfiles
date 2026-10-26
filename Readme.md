# Dotfiles

Personal dotfiles for macOS. Files are version-controlled here and symlinked into place by `install.sh`.

## Bootstrap a new machine

```bash
# 1. Install Homebrew, clone this repo, then install packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
mkdir ~/Code
git clone https://github.com/jmlrt/dotfiles.git ~/Code/dotfiles
brew bundle --file ~/Code/dotfiles/Brewfile

# 2. Symlink configs (force-replaces anything already at the destinations)
~/Code/dotfiles/install.sh

# 3. Personal symlink config (need Synoligy Drive sync configured)
~/SynologyDrive/Dotfiles/install.sh

# 4. Setup macOS keyboard window tiling (log out/in to apply)
~/Code/dotfiles/scripts/macos-tiling.sh

# 5. Setup my personal tools
gh auth login
gh repo clone jmlrt/clipmd ~/Code/clipmd
gh repo clone jmlrt/skills ~/Code/skills
gh repo clone jmlrt/spotfm ~/Code/spotfm
gh repo clone jmlrt/toolbox ~/Code/toolbox

for d in ~/Code/clipmd ~/Code/dotfiles ~/Code/skills ~/Code/spotfm ~/Code/toolbox; do
  (cd "$d" && pre-commit install)
done

uv tool install --editable ~/Code/clipmd
uv tool install --editable ~/Code/spotfm
uv tool install --editable ~/Code/toolbox/bw-backup

mkdir -p ~/.vibe/skills
ln -ns ~/Code/skills/<skill> ~/.vibe/skills/<skill>
```

## Notes

- To migrate the GPG signing key manually:

```bash
# old machine: export ASCII-armored (safe to move via any text channel, e.g. clipboard)
gpg --armor --export-secret-keys <KEYID> | pbcopy

# new machine: import, set ultimate trust, and point git at it
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg   # 700, not 600: without the execute bit gpg cannot read the directory
pbpaste | gpg --import
echo <KEYID>:6 | gpg --import-ownertrust
git config --file ~/.config/git/config.local user.signingkey <KEYID>   # the primary [SC] key ID — the [E] encryption subkey cannot sign
gpgconf --kill gpg-agent   # pick up the new gpg-agent.conf / pinentry

# verify, then delete the key material from wherever you staged it
echo test | gpg --clearsign > /dev/null && echo "signing OK"
```
