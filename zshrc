# Locales
export LANG=en_US.UTF-8

# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# History (replaces the oh-my-zsh defaults)
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history hist_ignore_dups hist_ignore_space hist_expire_dups_first share_history

# Completions (Homebrew zsh functions must be in FPATH before compinit)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit

# Editor (macOS ships vim; /usr/bin/vi is a symlink to it)
export EDITOR=vim

# ZSH Autosuggestions
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# FZF
command -v fzf > /dev/null && source <(fzf --zsh)

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
