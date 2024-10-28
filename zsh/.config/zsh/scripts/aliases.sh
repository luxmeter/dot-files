#!/usr/bin/env bash

# git
alias gst="git status -s"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga="git add"
alias ga='git add'
alias gp='git push'
alias gpf='git push --force'
alias gc='git commit'
alias gcf='git commit --amend --no-edit'
alias gd='git diff'
alias gco='git checkout '
alias gcb='git checkout -b'
alias grs='git remote show'
alias glol='git log --graph --oneline --decorate'
alias gbn='git rev-parse --abbrev-ref HEAD'
alias greseto='git reset origin/$(gbn)'
alias greset='git reset origin/master'

# fasd
# defaults: https://github.com/clvv/fasd
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias jj='fasd_cd -d -i' # cd with interactive selection

# needs to be screen, otherwise `clear` wouldn't clear the history...
alias tmux="TERM=screen-256color tmux -2"
alias ls='ls -h --color=auto --sort=time --sort=size -r'
alias ll="ls -lh --color=auto --sort=time --sort=size -r"
alias less="less -R"
alias man="man -P less"
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"
alias portainer='docker run -d -v "/var/run/docker.sock:/var/run/docker.sock" -p 9000:9000 portainer/portainer --no-auth -H unix:///var/run/docker.sock && open http://localhost:9000'
alias passwd_login='eval $(op signin my)'
alias grep='rg --smart-case --hidden --no-ignore-global --ignore-file ~/dot-files/nvim/.config/nvim/ignore-patterns'
alias rg="rg --smart-case --hidden --no-ignore-global --ignore-file ~/dot-files/nvim/.config/nvim/ignore-patterns"
alias fd="fd --hidden --no-ignore-parent --ignore-file ~/dot-files/nvim/.config/nvim/ignore-patterns"

alias build_svc="mvn  install -Dmaven.test.skip=true -DskipTests -Dfindbugs.skip=true -DskipTessa=true -T4 -pl '!container-tests'"
alias genpw='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16'
alias aclf='java -jar ~/Projects/sharedcloud/aclftool/target/aclftool-1.0-SNAPSHOT.jar'
alias nosleep='pmset noidle'
alias k='kubectl'

if [[ "$OSTYPE" == darwin* ]]; then
  alias ctags="/usr/local/bin/ctags"
  alias java8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
  alias java11='export JAVA_HOME=$(/usr/libexec/java_home -v 11)'
  alias java11-0-1='export JAVA_HOME=$(/usr/libexec/java_home -v 11.0.1)'
  alias cat=bat
else
  alias pbcopy='xsel -i -p && xsel -o -p | xsel -i -b'
  alias cat=bat
fi
