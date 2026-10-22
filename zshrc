# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# Homebrew completions (must be in FPATH before oh-my-zsh runs compinit)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
fi

# Oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  source "$ZSH/oh-my-zsh.sh"
fi

# ZSH Autosuggestions
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# FZF
command -v fzf > /dev/null && source <(fzf --zsh)

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
