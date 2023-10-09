#!/bin/bash

setup=(
	git
	misc
	nvim
	python
	tmux
	zsh
	code
)

if [[ "$OSTYPE" == linux* ]]; then
	setup+=(linux)
else
	pushd misc
	stow --ignore '.DS_Store' -v -R -t "$HOME/Library/Application Support/" .config
	popd
fi

for config in "${setup[@]}"; do
	# updating ZDOTDIR to .config/zsh
	# which means all from zsh created files will be put there
	# we don't want to persist them in git so we create a dir instead of a link
	if [[ "$config" == zsh ]]; then
		echo mkdir -p "$HOME/.config/$config/plugins"
		mkdir -p "$HOME/.config/$config/plugins"
	fi
	if [[ "$config" == code ]]; then
		echo mkdir -p "$HOME/.config/Code"
	fi
	stow --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
done
