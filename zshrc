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
fpath=( $DOT_FILES/zfunc "${fpath[@]}" )

# interactive terminal specific variables
# konsole didn't set this value
TERM=xterm-256color

source "$DOT_FILES/general.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "$DOT_FILES/scripts/keys.sh"
source "$DOT_FILES/scripts/aliases.sh"
source "$DOT_FILES/scripts/functions.sh"
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

if type jump &> /dev/null; then
	eval "$(jump shell)"
fi

# zsh completion init
compinit

if [[ "$(uname -s)" =~ "Linux" ]]; then
	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
	export SDKMAN_DIR="${HOME}/.sdkman"
	[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
fi
