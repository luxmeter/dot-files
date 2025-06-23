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
# The default Zsh value of WORDCHARS is, as of version 5.7.1:
# export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# want to break at / and =
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

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

# export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/quantum:$HOME/.kube/loadtest-jenkins"
export KUBECONFIG="$HOME/.kube/quantum:$HOME/.kube/loadtest-jenkins"

# core utils
export MANPATH="/opt/homebrew/opt/coreutils/libexec/man:${MANPATH}"

# fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
export FZF_DEFAULT_COMMAND="fd --hidden"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# misc
export SLH_SKIP_UPDATE=true
[[ -f "$HOME/.confidential" ]] && source "$HOME/.confidential"

# gpg agent for interactive shell
export GPG_TTY=$(tty)
. "$HOME/.cargo/env"

# needs to be defined here otherwise something after .zshenv alters it
path=(
  $HOME/.local/nvim/bin
  $HOME/.local/share/nvim/mason/bin/
  $HOME/.cargo/bin
  $HOME/.poetry/bin
  $PYENV_ROOT/shims
  $PYENV_ROOT/bin
  $HOME/.sdkman/bin
  $HOME/.local/bin
  $HOME/go/bin
  $HOME/.gem/ruby/3.0.0/bin
  /opt/mongodb/bin
  /opt/homebrew/bin
  /opt/homebrew/opt/coreutils/libexec/gnubin
  /opt/homebrew/opt/llvm/bin
  /opt/homebrew/sbin
  /usr/local/opt/ruby/bin
  /usr/local/lib/ruby/gems/3.0.0/bin
  /usr/local/{bin,sbin}
  /opt/mvnd-0.9.0/bin
  $path
)
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Setting autoloaded functions
# like `source` but better and lazy loaded
my_zsh_fpath="${DOT_FILES}/zsh/.config/zsh/autoloaded"
fpath=($my_zsh_fpath "$DOT_FILES/zsh/.config/zsh/plugins" $fpath)
if [[ -d "$my_zsh_fpath" ]]; then
  for func in $my_zsh_fpath/*; do
    autoload -Uz ${func:t}
  done
fi
unset my_zsh_fpath

# slow
[[ -f "${HOME}/Projects/adobe/caylak/scripts/caylak_adobe_scripts.sh" ]] && source "${HOME}/Projects/adobe/caylak/scripts/caylak_adobe_scripts.sh"

# direnv (switch automatically virtual env)
if type direnv > /dev/null; then
  _direnv_hook() {
    trap -- '' SIGINT;
    eval "$("/Users/caylak/.local/bin/direnv" export zsh)";
    trap - SIGINT;
  }
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z ${chpwd_functions[(r)_direnv_hook]} ]]; then
  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
fi
fi

source "$DOT_FILES/zsh/.config/zsh/scripts/keys.sh"
source "$DOT_FILES/zsh/.config/zsh/scripts/aliases.sh"
source "$DOT_FILES/zsh/.config/zsh/scripts/functions.sh"
