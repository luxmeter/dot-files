#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
setopt histignorespace
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
autoload -Uz promptinit
promptinit
prompt pure

# interactive terminal specific variables
# konsole didn't set this value
TERM=xterm-256color

source "$DOT_FILES/general.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "$DOT_FILES/keys.sh"
source "$DOT_FILES/aliases.sh"
source "$DOT_FILES/functions.sh"
source "$DOT_FILES/zshenv"
[ -f "${HOME}/Projects/scripts/caylak_adobe_scripts.sh" ] && source "${HOME}/Projects/scripts/caylak_adobe_scripts.sh"
source virtualenvwrapper.sh

# shell completions
if type jira &> /dev/null; then
	eval "$(jira --completion-script-zsh)"
fi

if type pipenv &> /dev/null; then
	eval "$(pipenv --completion)"
fi

export PATH=$PATH:/Users/caylak/.rhino/bin
