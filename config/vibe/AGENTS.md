# Global agent instructions

## Dotfiles are symlinks — keep them intact

Most of my home-directory configs are symlinks into `~/Code/dotfiles`
(`install.sh` there is the source of truth for the mapping), including:

- `~/.vibe/config.toml` -> `~/Code/dotfiles/config/vibe/config.toml`

Vibe writes its config symlink-safely now that
[mistralai/mistral-vibe#1385](https://github.com/mistralai/mistral-vibe/issues/1385)
is fixed (verified on v3.1.2: `~/.vibe/config.toml` stays a symlink and
writes land in the repo file). The same care applies to all symlinked
dotfiles: edit the file in the repo, never replace the symlink with a
regular file.

## Formatters: allow reformatting only, never content changes

- `shfmt` may run freely (with or without `-w`): it is a pure formatter and
  cannot change semantics.
- `yq -i` may run only with the identity expression: `yq -i '.' FILE`.
  That is the format-only case. Any other expression (`yq -i '.x = 1'`,
  del, sort, etc.) changes real content and must ask for approval, even
  when a technicality could let it through an allowlist prefix.
- `jq` is read-only (no write-back equivalent of -i in normal use); fine
  as-is.
