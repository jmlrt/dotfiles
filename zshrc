# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor
export EDITOR=nvim

# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# ZSH Autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# COMPLETION
autoload -U +X bashcompinit && bashcompinit

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PIPX
export PATH="$PATH:$HOME/.local/bin"
eval "$(register-python-argcomplete pipx)"

# UNBOUND
export PATH="/usr/local/sbin:$PATH"

# GNU SED
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"

# CUSTOM
export PATH="$HOME/bin:$PATH"

# CUSTOM PROFILES
if [ -f $HOME/.aliases.zsh ]; then
  source $HOME/.aliases.zsh
fi

if [ -f $HOME/.personal.zsh ]; then
  source $HOME/.personal.zsh
fi
