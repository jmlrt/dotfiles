# Keyboard Shortcuts

Consolidated reference of shortcuts defined or affected by this repo.

## Window tiling (native macOS, written by `scripts/macos-tiling.sh`)

All use the `cmd+ctrl` scheme. Applied after logging out/in.

| Shortcut | Action |
|---|---|
| `cmd+ctrl+left` / `cmd+ctrl+right` | Tile to left / right half |
| `cmd+ctrl+up` / `cmd+ctrl+down` | Tile to top / bottom half |
| `cmd+ctrl+U` / `cmd+ctrl+O` | Tile to top-left / top-right quarter |
| `cmd+ctrl+J` / `cmd+ctrl+L` | Tile to bottom-left / bottom-right quarter |
| `cmd+ctrl+Return` | Fill screen (maximize, not fullscreen) |
| `cmd+ctrl+C` | Center window (does not resize) |

Limitations:
- Delivered to the front app, which performs the action — apps that don't
  implement the standard Window > Move & Resize behavior (e.g. Bitwarden)
  ignore these shortcuts.
- Moving a window to another display has no native macOS hotkey.

## Ghostty (`config/ghostty/config`)

| Shortcut | Action |
|---|---|
| `cmd+@` (global) | Toggle quick terminal |

Ghostty's default `cmd+ctrl+arrow` binds are unbound so they don't shadow the
tiling shortcuts above.

## VS Code (`config/vscode/keybindings.json`)

No custom shortcuts — built-ins on `cmd+ctrl+left/right` (smart select, move
editor to group, terminal pane resize) are removed so the tiling shortcuts
reach the system.

## Maintenance

After changing any of the above: edits to Ghostty/VS Code configs apply
immediately (symlinked); tiling changes require re-running
`scripts/macos-tiling.sh` and logging out/in.
