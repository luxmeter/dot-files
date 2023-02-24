# i dont like vim mode in cmd line
bindkey -e # for emacs

# Who doesn't want home and end to work?
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[4~" end-of-line

# mac...
bindkey  "\e[3~"  delete-char
bindkey '\e[H'    beginning-of-line
bindkey '\e[F'    end-of-line

bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# history search (must be here bc something above masses with key bindings)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
