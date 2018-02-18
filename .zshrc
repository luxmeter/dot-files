#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -Uz promptinit
promptinit
prompt pure

export DOT_FILES="$HOME/dot-files"

source "$DOT_FILES/general.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "$DOT_FILES/keys.sh"
source "$DOT_FILES/aliases.sh"
source "$DOT_FILES/functions.sh"
