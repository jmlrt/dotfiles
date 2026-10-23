# History (replaces the oh-my-zsh defaults)
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history hist_ignore_dups hist_ignore_space hist_expire_dups_first share_history

# Completions (Homebrew zsh functions must be in FPATH before compinit)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit

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
if [ -f "$HOME/.elastic.zsh" ]; then
  source "$HOME/.elastic.zsh"
fi

if [ -f "$HOME/.personal.zsh" ]; then
  source "$HOME/.personal.zsh"
fi

# Editing helpers
alias edit_zshrc="vim $HOME/.zshrc"
alias reload_zshrc="source $HOME/.zshrc"

# Paths & Navigation
export PATH_DOWNLOADS="$HOME/Downloads"
export PATH_GIT="$HOME/Code"
export PKM_DIR="$HOME/Documents/PKM"

alias cddownloads="cd $PATH_DOWNLOADS"
alias cdgit="cd $PATH_GIT"
alias cdpkm="cd $PKM_DIR"

mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Git Aliases
alias g="git"
alias ga="git add"
alias gd="git diff"
alias gds="git diff --staged"
alias gmp="git_main_pull && git remote prune origin && git branch -vv | awk '/: gone\]/ { if (\$1 != \"*\" && \$1 != \"+\") print \$1 }' | xargs git branch -D"
alias gst="git st"

# Git Functions
git_browse_commits() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
git_delete_branches() {
    local branches
    branches=$(git branch |
        grep --invert-match '\*' |
        cut -c 3- |
        fzf --multi --preview="git log {} --")
    if [ -n "$branches" ]; then
        echo "$branches" | xargs git branch --delete --force
    fi
}

git_fetch_all() {
    for repo in $(find "$PATH_GIT" -type d -name .git); do
        git -C $(dirname "$repo") fetch --all
    done
}

git_main_pull() {
    main_branch_exists=$(git branch --list | grep -c -e '^[* ] main$')
    if [ "$main_branch_exists" -eq 1 ]; then
        default_branch=main
    else
        default_branch=master
    fi
    git checkout $default_branch
    git pull origin $default_branch
}

git_remote() {
    git_repo=$(basename "$(git_root)")
    git_user=$1
    git remote add "$git_user" "git@github.com:$git_user/$git_repo.git"
}

# Get the root directory of the current git repository
git_root() {
    git rev-parse --show-toplevel
}

prune_worktrees() {
    for w in $(git worktree list | awk '/.worktrees/ {print $1}'); do
        git worktree remove $w
    done
}

# GitHub Functions
# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
git_pr_checkout() {
    local pr_number

    pr_number=$(
        gh api 'repos/:owner/:repo/pulls' |
            jq --raw-output '.[] | "#\(.number) \(.title)"' |
            fzf |
            sed -E 's/^#([0-9]+).*/\1/'
    )

    if [ -n "$pr_number" ]; then
        gh pr checkout "$pr_number"
    fi
}

# Other Aliases
alias d="docker"
alias spotify_track='osascript -e '\''tell application "Spotify" to artist of current track & " - " & name of current track'\'
alias week_number="date +'So this is week: %U of %Y'"
alias yt="yt-dlp"

# Other Functions
# https://mattorb.com/the-many-faces-of-fzf/
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -9
    fi
}

# detox replacement (old habit: `detox -rv *`): normalize filenames to web-safe
# slugs (perl/tr/sed are macOS built-ins); recurses into directory arguments
slug() {
    local base name clean ext target f
    for f in "$@"; do
        if [ -d "$f" ]; then
            slug "$f"/*(N)
        fi
        base="${f%/*}"
        [ "$base" = "$f" ] && base="."
        name="${f##*/}"
        if [ "${name[1]}" = "." ]; then
            echo "skip (dotfile): $f"
            continue
        fi
        clean=$(printf '%s' "${name%.*}" | perl -CSD -pe 'use Unicode::Normalize qw(NFD); $_ = NFD($_); s/[^\p{ASCII}]//g; tr/A-Z/a-z/' | tr -cs 'a-z0-9' '-' | sed -E 's/^-+//; s/-+$//')
        if [ -z "$clean" ]; then
            echo "skip (nothing left after normalization): $f"
            continue
        fi
        ext="${name##*.}"
        [ "$ext" != "$name" ] && ext=".$ext" || ext=""
        target="$base/$clean$ext"
        [ "$f" != "$target" ] && mv -v -- "$f" "$target"
    done
}

# caffeinate replacement for the retired Hammerspoon Caffeine spoon
coffee() { caffeinate -di "$@"; }
alias decaf="pkill caffeinate"

update() {
    brew update && brew upgrade && brew cleanup
    uv tool upgrade --all
}
