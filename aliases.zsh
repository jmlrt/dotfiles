# .aliases.zsh

alias edit_aliases="nvim $HOME/.aliases.zsh"
alias reload_aliases="source $HOME/.aliases.zsh"

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

# https://mattorb.com/the-many-faces-of-fzf/
fcd() {
    if [ -z "$1" ]; then
        searchdir=.
    else
        searchdir=$1
    fi
    destdir=$(find "$searchdir" \( ! -regex '.*/\..*' \) ! -name __pycache__ ! -name venv ! -name .direnv -type d | fzf)
    if [ -z "$destdir" ]; then
        return 1
    else
        echo Destination: "$destdir"
        cd "$destdir"
    fi
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

github_open_commit() {
    org=$1
    repo=$2
    sha=$3
    open "https://github.com/$org/$repo/commit/$sha"
}

github_query_commit() {
    org=$1
    repo=$2
    sha=$3
    gh api "repos/$org/$repo/commits/$sha" --jq .commit
}

# Other Aliases
alias d="docker"
alias spotify_track='osascript -e '\''tell application "Spotify" to artist of current track & " - " & name of current track'\'
alias tre="trans en:fr"
alias trf="trans fr:en"
alias vim=nvim
alias week_number="date +'So this is week: %U of %Y'"

# Other Functions
# https://mattorb.com/the-many-faces-of-fzf/
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -9
    fi
}

tz() {
    # zones in /usr/share/zoneinfo
    for zone in US/Pacific US/Central US/Eastern UTC Europe/Amsterdam Europe/Paris Australia/Adelaide; do
        TZ="$zone"
        echo "$TZ"
        printf "  "
        TZ="$TZ" date
    done
}

update() {
    brew update && brew upgrade && brew cleanup
    uv tool upgrade --all
}
