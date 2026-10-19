# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Homebrew
# This is required to ensure compatibility with both macOS Intel & macOS M1
# because brew use different path on different archs
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(brew shellenv)"
fi

# Path
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH:$HOME/.local/bin:$HOME/bin:$HOME/go/bin"

# Homebrew completions (must be in FPATH before oh-my-zsh runs compinit)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
fi

# Oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  # shellcheck disable=SC2034
  ZSH_THEME="robbyrussell"
  source "$ZSH/oh-my-zsh.sh"
fi

# ZSH Autosuggestions
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# FZF
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Git
GPG_TTY=$(tty)
export GPG_TTY

# Direnv
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Custom profiles
if [ -f "$HOME/.aliases.zsh" ]; then
  source "$HOME/.aliases.zsh"
fi

if [ -f "$HOME/.elastic.zsh" ]; then
  source "$HOME/.elastic.zsh"
fi

if [ -f "$HOME/.personal.zsh" ]; then
  source "$HOME/.personal.zsh"
fi
