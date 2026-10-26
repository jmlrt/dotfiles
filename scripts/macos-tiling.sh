#!/bin/bash
# macOS keyboard window tiling (native replacement for the Hammerspoon
# WindowHalfsAndThirds spoon).
#
# Writes the Window > Move & Resize shortcuts into the system shortcut
# domain, using the same Cmd+Ctrl scheme as the old Hammerspoon setup:
#
#   halves:   cmd+ctrl+left/right/up/down
#   quarters: cmd+ctrl+U / cmd+ctrl+O (top)
#             cmd+ctrl+J / cmd+ctrl+L (bottom)
#
# Application key handling:
#   - Ghostty: config/ghostty/config unbinds cmd+ctrl+arrows in-app
#   - VS Code: config/vscode/keybindings.json removes the built-ins that
#     steal cmd+ctrl+left/right
#
# Undo: delete keys 240-247 from AppleSymbolicHotKeys (defaults delete ...
# does not work on dict entries; use PrefsEditor or re-add with enabled=0),
# then log out/in.
#
# Requires logging out (or rebooting) to take effect.

set -euo pipefail

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
  240 '{ enabled = 1; value = { parameters = (65535,123,9699328); type = standard; }; }' \
  241 '{ enabled = 1; value = { parameters = (65535,124,9699328); type = standard; }; }' \
  242 '{ enabled = 1; value = { parameters = (65535,126,9699328); type = standard; }; }' \
  243 '{ enabled = 1; value = { parameters = (65535,125,9699328); type = standard; }; }' \
  244 '{ enabled = 1; value = { parameters = (117,32,1310720); type = standard; }; }' \
  245 '{ enabled = 1; value = { parameters = (111,31,1310720); type = standard; }; }' \
  246 '{ enabled = 1; value = { parameters = (106,38,1310720); type = standard; }; }' \
  247 '{ enabled = 1; value = { parameters = (108,37,1310720); type = standard; }; }'

echo "Tiling shortcuts written. Log out and back in to apply, then verify:"
echo "  cmd+ctrl+right / cmd+ctrl+up / cmd+ctrl+U should tile the front window."
