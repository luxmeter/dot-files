#! /usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

while read -r -d '' config; do
    # updating ZDOTDIR to .config/zsh
    # which means all from zsh created files will be put there
    # we don't want to persist them in git so we create a dir instead of a link
    if [[ "$config" == zsh ]]; then
        mkdir -p "$HOME/.config/$config/plugins"
    fi
    if [[ "$config" == code ]]; then
        mkdir -p "$HOME/.config/Code"
    fi
    stow --ignore './.git' --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
done < <(find . -maxdepth 1 ! \( -path ./.git -or -path . -or -path ./common -or -path ./linux -or -path ./macos \) -type d -exec sh -c 'printf "${0#./}\0"' '{}' \;)

shopt -s globstar nullglob
if [[ "$OSTYPE" =~ linux* ]]; then
    cd linux
    for config in *; do
        stow --ignore './.git' --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
    done
    cd - >/dev/null
elif [[ "$OSTYPE" =~ darwin* ]]; then
    cd macos
    for config in *; do
        stow --ignore './.git' --ignore '.DS_Store' -v -R -t "$HOME" "$config" 2>&1 | grep -iv "BUG in find_stowed_path"
    done
    cd - >/dev/null
fi
