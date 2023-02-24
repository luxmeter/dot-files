export ZDOTDIR="$HOME/.config/zsh"
export DOT_FILES="$HOME/dot-files"
export HISTFILE="$HOME/.config/zsh/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'

# highlight searches in less in tmux
# https://unix.stackexchange.com/questions/179173/make-less-highlight-search-patterns-instead-of-italicizing-them
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[39;49m'

# affects deletion of words (alt+backspace or ctrl-w)
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# home-brew
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export MANPATH="/opt/homebrew/share/man:${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# lang
if [[ -z "$LANG" ]]; then
  export LC_ALL=de_DE.UTF-8
  export LANG=de_DE.UTF-8
fi

# java
export JAVA_HOME=~/.sdkman/candidates/java/current
export M2_HOME=~/.sdkman/candidates/maven/current
export SDKMAN_DIR="${HOME}/.sdkman"

# python
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
  export PYTHON_VERSION=3.10.3
fi
# export WORKON_HOME=$HOME/.virtualenvs
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SHELL=zsh
export PYTHONSTARTUP=$HOME/.pythonrc
export VIRTUALENV_PYTHON="$HOME/.pyenv/shims/python3"
# even though poetry is set up to create in local folder the venv, currently
export POETRY_VIRTUALENVS_PATH="$HOME/.virtualenvs"

# core utils
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

# fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow -g '!.git' -g '!*.min.css'"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# misc
export SLH_SKIP_UPDATE=true
[[ -f "$HOME/.confidential" ]] && source "$HOME/.confidential"

# gpg agent for interactive shell
export GPG_TTY=$(tty)
