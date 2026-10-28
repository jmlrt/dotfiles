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

plist=~/Library/Preferences/com.apple.symbolichotkeys.plist

# PlistBuddy writes typed integers; `defaults -dict-add` writes the parameters
# as strings, which macOS silently ignores.
set_key() {
  local id=$1 ascii=$2 keycode=$3 mods=$4
  /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:$id" "$plist" 2>/dev/null || true
  /usr/libexec/PlistBuddy \
    -c "Add :AppleSymbolicHotKeys:$id dict" \
    -c "Add :AppleSymbolicHotKeys:$id:enabled bool true" \
    -c "Add :AppleSymbolicHotKeys:$id:value dict" \
    -c "Add :AppleSymbolicHotKeys:$id:value:type string standard" \
    -c "Add :AppleSymbolicHotKeys:$id:value:parameters array" \
    -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $ascii" \
    -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $keycode" \
    -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $mods" \
    "$plist"
}

set_key 240 65535 123 9699328
set_key 241 65535 124 9699328
set_key 242 65535 126 9699328
set_key 243 65535 125 9699328
set_key 244 117 32 1310720
set_key 245 111 31 1310720
set_key 246 106 38 1310720
set_key 247 108 37 1310720
killall cfprefsd

echo "Tiling shortcuts written. Log out and back in to apply, then verify:"
echo "  cmd+ctrl+right / cmd+ctrl+up / cmd+ctrl+U should tile the front window."
