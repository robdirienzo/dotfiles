# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
# hub_path=$(which hub)
# if (( $+commands[hub] ))
# then
#   alias git=$hub_path
# fi

# The rest of my fun git aliases
alias ga='git add --all'
alias gaa='git all'
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git difftool'
alias go='git checkout'
alias gc='git commit'
alias gca='git commit -a'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
# Show list of files changed in a commit
# Follow with commit hash
alias gdl="git diff-tree --no-commit-id --name-only -r $1"
