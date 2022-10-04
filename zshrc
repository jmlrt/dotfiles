# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor
export EDITOR=nvim

# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# COMPLETION
autoload -U +X bashcompinit && bashcompinit

# Ansible
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# ASDF
source $(brew --prefix asdf)/libexec/asdf.sh

# ASDF-DIRENV
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

# ASDF-JAVA
source ~/.asdf/plugins/java/set-java-home.zsh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# GCLOUD
export CLOUDSDK_PYTHON=python3
export CLOUDSDK_GSUTIL_PYTHON=python3
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
GCLOUD_HOME=$(asdf where gcloud)
source $GCLOUD_HOME/completion.zsh.inc
source $GCLOUD_HOME/path.zsh.inc

# GH CLI
export GPG_TTY

# PIPX
export PATH="$PATH:$HOME/.local/bin"
eval "$(register-python-argcomplete pipx)"

# UNBOUND
export PATH="/usr/local/sbin:$PATH"

# VAULT
complete -o nospace -C /usr/local/bin/vault vault

# CUSTOM
export PATH="$HOME/bin:$PATH"

# CUSTOM PROFILES
if [ -f $HOME/.aliases.zsh ]; then
  source $HOME/.aliases.zsh
fi

if [ -f $HOME/.elastic.zsh ]; then
  source $HOME/.elastic.zsh
fi
