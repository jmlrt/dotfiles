# Global agent instructions

## Dotfiles are symlinks — keep them intact

Most of my home-directory configs are symlinks into `~/Code/dotfiles`
(`install.sh` there is the source of truth for the mapping), including:

- `~/.vibe/config.toml` -> `~/Code/dotfiles/config/vibe/config.toml`

Vibe saves its config with an atomic write (temp file + rename), so **any
Vibe-side config write replaces the symlink with a regular file**. This
happens silently on every "always allow" approval (which appends to
`[tools.bash]` allowlist or tool `permission` entries), and on settings
changes made via `/config`.

### Required behavior

Whenever an "always allow" approval or any other change writes to
`~/.vibe/config.toml`:

1. Warn me that the symlink was (or will be) replaced by a regular file.
2. Suggest integrating the change into the dotfiles repo: copy the new
   content into `~/Code/dotfiles/config/vibe/config.toml`, then re-create
   the symlink (`ln -nsf ~/Code/dotfiles/config/vibe/config.toml
   ~/.vibe/config.toml`, or re-run `~/Code/dotfiles/install.sh`).
3. Do this before I commit anything else, so the repo and live config do not
   silently diverge.

The same care applies to other symlinked dotfiles: edit the file in the
repo, never replace the symlink with a regular file.

## Formatters: allow reformatting only, never content changes

- `shfmt` may run freely (with or without `-w`): it is a pure formatter and
  cannot change semantics.
- `yq -i` may run only with the identity expression: `yq -i '.' FILE`.
  That is the format-only case. Any other expression (`yq -i '.x = 1'`,
  del, sort, etc.) changes real content and must ask for approval, even
  when a technicality could let it through an allowlist prefix.
- `jq` is read-only (no write-back equivalent of -i in normal use); fine
  as-is.
