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

fpath=( $DOT_FILES/zfunc "${fpath[@]}" )

source "$DOT_FILES/general.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "$DOT_FILES/scripts/keys.sh"
source "$DOT_FILES/scripts/aliases.sh"
source "$DOT_FILES/scripts/functions.sh"
source "$DOT_FILES/zshenv"

# slow
[[ -f "${HOME}/Projects/scripts/caylak_adobe_scripts.sh" ]] && source "${HOME}/Projects/scripts/caylak_adobe_scripts.sh"

## shell completions
## if type jira &> /dev/null; then
## 	eval "$(jira --completion-script-zsh)"
## fi

## if type jump &> /dev/null; then
## 	eval "$(jump shell)"
## fi

source virtualenvwrapper_lazy.sh

# slow
#if [[ "$(uname -s)" =~ "Linux" ]]; then
#	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#	export SDKMAN_DIR="${HOME}/.sdkman"
#	[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
#fi
# for performance analysis (look at top of file)
# zprof

# result of eval "$(pyenv init -)"
export PATH="/Users/caylak/.pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
source '/usr/local/Cellar/pyenv/1.2.20/libexec/../completions/pyenv.zsh'
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}
