# Login environment (sourced once; inherited by all interactive shells)

# Locales
export LANG=en_US.UTF-8

# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# Editor (macOS ships vim; /usr/bin/vi is a symlink to it)
export EDITOR=vim

# Obsidian CLI (the `obsidian` command lives inside the app bundle)
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
