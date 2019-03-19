#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [[ "$(uname -s)" =~ "Darwin" ]]; then
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
	export M2_HOME=/usr/local/maven/3.5.0/bin
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

export WORKON_HOME=$HOME/.virtualenvs
if [[ ! -d "WORKON_HOME" ]]; then
	mkdir -p $WORKON_HOME
fi
export LC_ALL=de_DE.UTF-8
export LANG=de_DE.UTF-8

export PATH="$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:$PATH"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"
export FZF_DEFAULT_COMMAND='fd --follow'

export EDITOR="nvim"
export PYTHONSTARTUP=$HOME/.pythonrc
export VIRTUALENVWRAPPER_PYTHON="$(which python3)"
export VIRTUALENV_PYTHON="$(which python3)"
export DOT_FILES="$HOME/dot-files"
