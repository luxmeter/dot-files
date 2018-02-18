#!/bin/zsh
export DOT_FILES="${0:h}"
echo "$DOT_FILES"

ln -s -f "${DOT_FILES}/prezto" "${HOME}/.zprezto"
ln -s -f "${DOT_FILES}/gitignore_global" "${HOME}/.gitignore_global"
ln -s -f "${DOT_FILES}/pythonrc.py" "${HOME}/.pythonrc"
ln -s -f "${DOT_FILES}/config" "${HOME}/.config"
ln -s -f "${DOT_FILES}/pylintrc" "${HOME}/.pylintrc"
ln -s -f "${DOT_FILES}/zprofile" "${HOME}/.zprofile"
ln -s -f "${DOT_FILES}/tmux.conf" "${HOME}/.tmux"
ln -s -f "${DOT_FILES}/vimrc" "${HOME}/.vimrc"
ln -s -f "${DOT_FILES}/gitconfig" "${HOME}/.gitconfig"
ln -s -f "${DOT_FILES}/gitmodules" "${HOME}/.gitmodules"
ln -s -f "${DOT_FILES}/tmux" "${HOME}/.tmux"

echo "export DOT_FILES=${DOT_FILES}" >> "${HOME}/.zshenv"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s -f "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

mkdir "${HOME}/.vim" 2> /dev/null
ln -s -f "${DOT_FILES}/vim/"^bundle "${HOME}/.vim"
