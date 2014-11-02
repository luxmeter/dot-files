# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git command-not-found extract history mvn npm sublime systemd colored-man)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias pdflatex="pdflatex -interaction=nonstopmode -halt-on-error"

function usage {
 find $1 -maxdepth 1 -type d -exec du -sh {} \; | sort -h
}

function livereload {
	if [ -e "Gemfile" ]; then
		echo "Starting livereload..."
		bundle exec guard
	else
		echo "Couldn't find Gemfile. Initiating livereload..."
		bundle init
		echo "gem 'guard'" >> Gemfile
		echo "gem 'guard-livereload'" >> Gemfile
		echo "gem 'guard-sass'" >> Gemfile
		bundle exec guard init livereload sass
		echo "Initiating complete, but you should check Guardfile and its properties!"
		livereload
	fi
}

# Customize to your needs...
# bashlike inline comments
setopt interactivecomments

source ~/.lscolors

[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm"  # This loads RVM

function server {
	if [ $# -eq 1 ]; then
		python -m http.server $1
	else
		python -m http.server 8080
	fi
}

function svn-git-up {
	local SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	if [ $# -eq 1 ]; then
		echo "svn diff -r $1:HEAD --summarize > ~/svn_update_raw"
		svn diff -r $1:HEAD --summarize > ~/svn_update_raw
		if [ -f ~/svn_update_raw ]; then
			echo 'sed -e "s/[A|M|D][[:space:]]\{7\}//g" ~/svn_update_raw > ~/svn_update'
			sed -e "s/[A|M|D][[:space:]]\{7\}//g" ~/svn_update_raw > ~/svn_update
			if [ -f ~/svn_update ]; then
				echo "git add -f --all ..."
				git add -f --all $(for i in `cat ~/svn_update`; do test -e $i && echo "$i"; done)
			else
				echo "error: could not found svn_update"
			fi
		else
			echo "error: could not found svn_update_raw"
		fi
	else
		echo "need previous revision number"
	fi
	# restore $IFS
	IFS=$SAVEIFS
}


# radeon gpu power management
alias profilepm='sudo bash -c "echo profile > /sys/class/drm/card0/device/power_method"'
alias auto='profilepm && sudo bash -c "echo auto > /sys/class/drm/card0/device/power_profile"'
alias low='profilepm && sudo bash -c "echo low > /sys/class/drm/card0/device/power_profile"'
alias mid='profilepm && sudo bash -c "echo mid > /sys/class/drm/card0/device/power_profile"'
alias high='profilepm && sudo bash -c "echo high > /sys/class/drm/card0/device/power_profile"'
alias dynpm='sudo bash -c "echo dynpm > /sys/class/drm/card0/device/power_method"'
alias gpu="sudo cat /sys/kernel/debug/dri/0/radeon_pm_info /sys/class/drm/card0/device/power_method"

##autoload bashcompinit
#bashcompinit
#autoload compinit
#compinit
#eval "$(register-python-argcomplete tir-create)"

source ~/scripts/bash/git-shortcuts.sh

#if [ -e /usr/share/terminfo/x/xterm-256color ]; then
#        export TERM='xterm-256color'
#else
#        export TERM='xterm-color'
#fi

