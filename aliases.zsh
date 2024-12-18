# .aliases.zsh

alias edit_aliases="nvim $HOME/.aliases.zsh"
alias reload_aliases="source $HOME/.aliases.zsh"

# Git Aliases & Functions

alias g="git"
alias ga="git add"
alias gd="git diff"
alias gds="git diff --staged"
alias gmp="git_main_pull && git_cleanup_branches.sh"
alias gst="git st"

git_fetch_all() {
    for repo in $(find "$HOME"/git -type d -name .git); do
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
    git_root=$(git rev-parse --show-toplevel)
    git_repo=$(basename "$git_root")
    git_user=$1
    git remote add "$git_user" "git@github.com:$git_user/$git_repo.git"
}

github_query_commit() {
    org=$1
    repo=$2
    sha=$3
    curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$org/$repo/commits/$sha" | jq .commit
}

github_open_commit() {
    org=$1
    repo=$2
    sha=$3
    open "https://github.com/$org/$repo/commit/$sha"
}

# Kubectl Aliases

alias k="kubectl"
alias kapply="kubectl apply -f"
alias kctx="kubectx"
alias kd="kubectl describe"
alias kdd="kubectl describe deployments"
alias kdds="kubectl describe daemonsets"
alias kdp="kubectl describe pod"
alias kds="kubectl describe services"
alias kdst="kubectl describe statefulsets"
alias kexec="kubectl exec -it"
alias kg="kubectl get"
alias kga="kubectl get all"
alias kgd="kubectl get deployments"
alias kgds="kubectl get daemonsets"
alias kge="kubectl get events --sort-by='.metadata.creationTimestamp'"
alias kgn="kubectl get nodes"
alias kgp="kubectl get pod"
alias kgs="kubectl get services"
alias kgst="kubectl get statefulsets"
alias kl="kubectl logs -f"
alias kns="kubens"
alias krm="kubectl delete"
alias krmd="kubectl delete deployment"
alias krmp="kubectl delete pod"

# Other Aliases & Functions
alias cloudshell='gcloud cloud-shell ssh'
alias d="docker"
alias pip_upgrade="pip list --local --outdated --format freeze | cut -d= -f1 | xargs pip install --upgrade"
alias spotify_track='osascript -e '\''tell application "Spotify" to artist of current track & " - " & name of current track'\'
alias tre="trans en:fr"
alias trf="trans fr:en"
alias vim=nvim
alias week_number="date +'So this is week: %U of %Y'"
alias yt=" youtube-dl"

mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

venv_tmp() {
    packages=($@)
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    python3 -m venv venv
    ./venv/bin/pip install --upgrade pip
    ./venv/bin/pip install --upgrade setuptools
    ./venv/bin/pip install --upgrade wheel
    ./venv/bin/pip install --upgrade ipython
    for pkg in ${packages[@]}; do
        ./venv/bin/pip install "$pkg"
    done
    source ./venv/bin/activate
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
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
    pipx upgrade-all
}

# FZF Functions

# https://mattorb.com/the-many-faces-of-fzf/
fcd() {
    set -x
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

# https://mattorb.com/the-many-faces-of-fzf/
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -9
    fi
}

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
    git branch |
        grep --invert-match '\*' |
        cut -c 3- |
        fzf --multi --preview="git log {} --" |
        xargs --no-run-if-empty git branch --delete --force
}

# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
git_pr_checkout() {
    local pr_number

    pr_number=$(
        gh api 'repos/:owner/:repo/pulls' |
            jq --raw-output '.[] | "#\(.number) \(.title)"' |
            fzf |
            sed 's/^#\([0-9]\+\).*/\1/'
    )

    if [ -n "$pr_number" ]; then
        gh pr checkout "$pr_number"
    fi
}

git_clean_squash_merge_branches_master() {
  git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done
}

git_clean_squash_merge_branches_main() {
  git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done
}

vault_totp() {
    vault read --field=code "totp/code/$(vault list totp/keys | fzf)"
}

vault_totp_copy() {
    if [ "$1" = "list" ]; then
        vault list totp/keys
        return
    fi
    vault read -field=code "totp/code/$1" | pbcopy
    echo "TOTP for $1 copied to clipboard"
}
