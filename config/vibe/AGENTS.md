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

## GitHub: connector vs `gh` CLI

- Use the `connector_github_app` tools for reads where the full structured
  object is useful: issue threads with comments, PR details/diff/reviews,
  semantic issue search. Connector schemas load lazily via
  `search_tool_functions`, so a connector you never call costs no context.
- Use `gh` for anything that mutates (create/update PRs, issues, comments):
  the GitHub App token is read-only for pull requests (403 on
  `create_pull_request`); `gh` authenticates with your own keychain token.
  `gh auth status`, `gh pr create`, `gh pr view` are allowlisted.
- When only a few fields of a large object are needed (release notes, issue
  state, PR status), prefer `gh api ... -q '<jq>'` or `gh ... --json FIELDS
  --jq ...` over the connector: connector results land in the conversation
  verbatim (a full release object is ~20k chars) and persist for the rest
  of the session, while `gh -q` returns only the selected fields.
- Rule of thumb: connector = full-payload reads; `gh` + `jq` = selective
  reads and all writes. Check `/context` if the tools/conversation share
  grows.

## Formatters: allow reformatting only, never content changes

- `shfmt` may run freely (with or without `-w`): it is a pure formatter and
  cannot change semantics.
- `yq -i` may run only with the identity expression: `yq -i '.' FILE`.
  That is the format-only case. Any other expression (`yq -i '.x = 1'`,
  del, sort, etc.) changes real content and must ask for approval, even
  when a technicality could let it through an allowlist prefix.
- `jq` is read-only (no write-back equivalent of -i in normal use); fine
  as-is.
