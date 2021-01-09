#!/bin/sh

alias gst="git status -s"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga="git add"
# needs to be screen, otherwise `clear` wouldn't clear the history...
alias tmux="TERM=screen-256color tmux -2"
alias less="less -R"
# alias jq="jq -C"
alias agl="ag --pager=less"
alias man="man -P less"
alias vi="vim"
alias portainer='docker run -d -v "/var/run/docker.sock:/var/run/docker.sock" -p 9000:9000 portainer/portainer --no-auth -H unix:///var/run/docker.sock && open http://localhost:9000'
alias gcb='git checkout -b'
alias passwd_login='eval $(op signin my)'
if [[ "$OSTYPE" == darwin* ]]; then
    alias ctags="/usr/local/bin/ctags"
    alias java8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
    alias java11='export JAVA_HOME=$(/usr/libexec/java_home -v 11)'
    alias java11-0-1='export JAVA_HOME=$(/usr/libexec/java_home -v 11.0.1)'
else
    alias pbcopy='xsel -i -p && xsel -o -p | xsel -i -b'
fi
alias build_svc="mvn  install -Dmaven.test.skip=true -DskipTests -Dfindbugs.skip=true -DskipTessa=true -T4 -pl '!container-tests'"
if [[ "$OSTYPE" == linux*  ]]; then
    alias cat=batcat
else
    alias cat=bat
fi
