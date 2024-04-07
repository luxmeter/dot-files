#HIST_IGNORE_SPACE for performance analysis (look at bottom of file)
# zmodload zsh/zprof
# https://pnguyen.io/posts/speed-up-zsh-custom-functions/
# source $ZDOTDIR/.zshenv

# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# navigation
setopt AUTO_CD                # Go to folder path without using cd.

setopt AUTO_PUSHD             # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS      # Do not store duplicates in the stack.
setopt PUSHD_SILENT           # Do not print the directory stack after pushd or popd.

setopt CORRECT                # Spelling correction
setopt CDABLE_VARS            # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB          # Use extended globbing syntax.

# history
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
# fucking macos overrides zshenv
export HISTFILE="$HOME/.config/zsh/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# misc
setopt ZLE                    # use magic (this is default, but it can't hurt!)
setopt NO_HUP
setopt NO_FLOW_CONTROL        # If I could disable Ctrl-s completely I would!
setopt NO_CLOBBER             # Keep echo "station" > station from clobbering station
setopt NO_CASE_GLOB           # Case insensitive globbing
setopt NUMERIC_GLOB_SORT      # Be Reasonable!
setopt INTERACTIVE_COMMENTS   # in interactive shell allows commenting the current command

# for alacritty and karabiner config on macos
# https://github.com/alacritty/alacritty/issues/4048#issuecomment-1024966230
bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

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

# colors
eval "$(dircolors -b $DOT_FILES/zsh/.config/zsh/dircolors)"

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

# completion
source $DOT_FILES/zsh/.config/zsh/completion.zsh

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

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_completion "esc/conda-zsh-completion" false

if [[ ! -d $ZDOTDIR/plugins/powerlevel10k ]]; then
  git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $ZDOTDIR/plugins/powerlevel10k
fi

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# fasd
type fasd > /dev/null && eval "$(fasd --init auto)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f "$DOT_FILES/zsh/.config/zsh/.p10k.zsh" ]] || source "$DOT_FILES/zsh/.config/zsh/.p10k.zsh"
# if you need to analyse perf uncomment below
# zprof

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.poetry/bin:$PATH"
# export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/quantum:$HOME/.kube/loadtest-jenkins"
export KUBECONFIG="$HOME/.kube/quantum:$HOME/.kube/loadtest-jenkins"
