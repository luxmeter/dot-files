#!/bin/bash

##! /usr/bin/env bash
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

while read -r -d '' config; do
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
    echo stow --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
done < <(find . ! \( -path . -or -path ./common -or -path ./linux -or -path ./macos \) -type d -maxdepth 1 -execdir printf '%s\0' {} +)

if [[ "$OSTYPE" == linux* ]]; then
    cd linux
    while read -r -d '' config; do
        # echo $config
        echo stow --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
    done < <(find . ! -path . -type d -maxdepth 1 -execdir printf '%s\0' {} +)
    cd - >/dev/null
elif [[ "$OSTYPE" == darwin* ]]; then
    cd macos
    while read -r -d '' config; do
        # echo $config
        echo stow --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
    done < <(find . ! -path . -type d -maxdepth 1 -execdir printf '%s\0' {} +)
    cd - >/dev/null
fi
