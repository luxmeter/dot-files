#!/bin/zsh

SOURCE="${(%):-%N}"
export DOT_FILES="$( cd "$( dirname "${SOURCE}" )" && pwd )"

(cd "$DOT_FILES"; git submodule update --depth 1 --init --recursive)
(cd "$DOT_FILES/prezto"; git submodule update --depth 1 --init --recursive)

# ln -s -f "${DOT_FILES}/fzf" "${HOME}/.fzf"
ln -s -f "${DOT_FILES}/prezto" "${HOME}/.zprezto"
ln -s -f "${DOT_FILES}/gitignore_global" "${HOME}/.gitignore_global"
ln -s -f "${DOT_FILES}/pythonrc.py" "${HOME}/.pythonrc.py"
ln -s -f "${DOT_FILES}/config" "${HOME}/.config"
ln -s -f "${DOT_FILES}/pylintrc" "${HOME}/.pylintrc"
ln -s -f "${DOT_FILES}/zprofile" "${HOME}/.zprofile"
ln -s -f "${DOT_FILES}/tmux.conf" "${HOME}/.tmux"
ln -s -f "${DOT_FILES}/vimrc" "${HOME}/.vimrc"
ln -s -f "${DOT_FILES}/gitconfig" "${HOME}/.gitconfig"
ln -s -f "${DOT_FILES}/gitmodules" "${HOME}/.gitmodules"
ln -s -f "${DOT_FILES}/tmux" "${HOME}/.tmux"
ln -s -f "${DOT_FILES}/tmux-macosx" "${HOME}/.tmux-macosx"

echo "export DOT_FILES=${DOT_FILES}" >> "${HOME}/.zshenv"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s -f "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

mkdir -p "${HOME}/.vim/bundle" 2> /dev/null
ln -s -f "${DOT_FILES}/vim/"^bundle "${HOME}/.vim"
ln -s -f "${DOT_FILES}/vim/bundle/Vundle.vim" "${HOME}/.vim/bundle/"

cat<<EOF
Don't forget to install these dependencies for smooth user experience:
* fzf https://github.com/luxmeter/dot-files
* ag - the silver searcher
EOF
