#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
  export PYTHON_VERSION=3.8.5
else
  export PYTHON_VERSION=3.9.0
fi

#
# Editors
#

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

if [[ "$OSTYPE" == darwin* ]]; then
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home
	export M2_HOME=/usr/local/Cellar/maven/3.5.4
else
	export JAVA_HOME=~/.sdkman/candidates/java/current
	export M2_HOME=~/.sdkman/candidates/maven/current
	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
	export SDKMAN_DIR="${HOME}/.sdkman"
	source "${HOME}/.sdkman/bin/sdkman-init.sh"
fi

if [[ -f "$HOME/.confidential" ]]; then
	source "$HOME/.confidential"
fi

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

export WORKON_HOME=$HOME/.virtualenvs
if [[ ! -d "WORKON_HOME" ]]; then
	mkdir -p $WORKON_HOME
fi
export LC_ALL=de_DE.UTF-8
export LANG=de_DE.UTF-8

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.poetry/bin:$HOME/.pyenv/shims:$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.sdkman/bin:/usr/local/opt/coreutils/libexec/gnubin:$HOME/.local/bin:$HOME/go/bin:/opt/mongodb/bin:$PATH"
export PYENV_SHELL=bash
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow -g '!.git' -g '!*.min.css'"

export EDITOR="nvim"
export PYTHONSTARTUP=$HOME/.pythonrc
export VIRTUALENVWRAPPER_PYTHON="$HOME/.pyenv/versions/$PYTHON_VERSION/bin/python"
export VIRTUALENV_PYTHON="$HOME/.pyenv/shims/python3"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export DOT_FILES="$HOME/dot-files"
export SLH_SKIP_UPDATE=true
if [[ "$OSTYPE" == darwin* ]]; then
  export SHELL=/usr/local/bin/zsh
else
  export SHELL=/usr/bin/zsh
fi

