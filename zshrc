# for performance analysis (look at bottom of file)
# zmodload zsh/zprof
#
# TODO https://pnguyen.io/posts/speed-up-zsh-custom-functions/

# Speeds up load time
DISABLE_UPDATE_PROMPT=true
DISABLE_UNTRACKED_FILES_DIRTY="true"

setopt histignorespace
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$DOT_FILES/general.zsh"
source "$DOT_FILES/scripts/keys.sh"
source "$DOT_FILES/scripts/aliases.sh"
source "$DOT_FILES/scripts/functions.sh"
source "$DOT_FILES/zshenv"

#-----------------------------------------------------
# Setting autoloaded functions
#
my_zsh_fpath=${DOT_FILES}/autoloaded

fpath=($my_zsh_fpath $fpath)

if [[ -d "$my_zsh_fpath" ]]; then
    for func in $my_zsh_fpath/*; do
        autoload -Uz ${func:t}
    done
fi
unset my_zsh_fpath

# slow
[[ -f "${HOME}/Projects/scripts/caylak_adobe_scripts.sh" ]] && source "${HOME}/Projects/scripts/caylak_adobe_scripts.sh"

source "${HOME}/.pyenv/versions/3.8.5/bin/virtualenvwrapper.sh"


# slow
#if [[ "$(uname -s)" =~ "Linux" ]]; then
#	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#	export SDKMAN_DIR="${HOME}/.sdkman"
#	[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
#fi
# for performance analysis (look at top of file)

# result of eval "$(pyenv init -)"

# gpg agent for interactive shell
export GPG_TTY=$(tty)
# zprof
