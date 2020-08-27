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
fi

#
# Editors
#

export EDITOR='neovim'
export VISUAL='neovim'
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

export PATH="$HOME/.poetry/bin:$PATH"

if [[ "$OSTYPE" == darwin* ]]; then
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home
	export M2_HOME=/usr/local/Cellar/maven/3.5.4
else
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
	export M2_HOME=/usr/share/maven
fi

if [[ -d "$HOME/miniconda3/bin" ]]; then
	export PATH="$HOME/miniconda3/bin:$PATH"
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

export PATH="$HOME/.pyenv/shims:/usr/local/opt/coreutils/libexec/gnubin:$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:/opt/mongodb/bin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
export FZF_DEFAULT_COMMAND='fd --follow --type f'

export EDITOR="nvim"
export PYTHONSTARTUP=$HOME/.pythonrc
export VIRTUALENVWRAPPER_PYTHON="$HOME/.pyenv/versions/3.8.5/bin/python3"
export VIRTUALENV_PYTHON="$HOME/.pyenv/versions/3.8.5/bin/python3"
export DOT_FILES="$HOME/dot-files"
export SLH_SKIP_UPDATE=true
export SHELL=/usr/local/bin/zsh
export PYENV_SHELL=bash

