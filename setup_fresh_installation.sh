#!  /usr/bin/env bash

set -u # exit on usage of undeclared variables
# set -x # debug

_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_file="${_dir}/$(basename "${BASH_SOURCE[0]}")"
_base="$(basename ${_file} .sh)"
_root="${HOME}"

command_exists() {
	type "$1" &> /dev/null
}

install_git() {
	if ! command_exists git; then
		echo "Git not found. Installing..."
		sudo apt -q install git
	fi
}

install_curl() {
	if ! command_exists curl; then
		echo "curl not found. Installing..."
		sudo apt -q install curl
	fi
}

install_fonts() {
	if ! ls ~/.local/share/fonts 2> /dev/null | grep -qi 'source code'; then
		echo "Fonts not found. Installing Fonts..."
		git clone --quiet --depth 1 https://github.com/powerline/fonts.git ${HOME}/powerline-fonts
		cd powerline-fonts
		chmod +x install.sh
		./install.sh
		cd -
		rm -rf powerline-fonts
	fi
}

install_zsh() {
	if ! command_exists zsh; then
		echo "ZSH not found. Installing..."
		sudo apt -q install zsh
		chsh -s $(which zsh)
	fi
}

install_jump() {
	if ! command_exists jump; then
		echo "jump not found. Installing..."
		wget https://github.com/gsamokovarov/jump/releases/download/v0.22.0/jump_0.22.0_amd64.deb
		sudo dpkg -i jump_0.22.0_amd64.deb
	fi
}

install_jdk() {
	if ! command_exists java; then
		echo "Java not found. Installing..."
		sudo apt install openjdk-11-jdk openjdk-11-source
	fi
}

install_neovim() {
	if ! command_exists nvim; then
		echo "NeoVim not found. Installing..."
		sudo apt -q install neovim

		sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
		sudo update-alternatives --config vi
		sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
		sudo update-alternatives --config vim
		sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
		sudo update-alternatives --config editor

		curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
}

install_tmux() {
	if ! command_exists tmux; then
		echo "Tmux not found. Installing..."
		sudo apt -q install tmux
	fi
}

install_python3() {
	if ! command_exists python3.7; then
		echo "python3.7 not found. Installing..."
		sudo apt -q install python3.7 python3.7-dev python3-pip python python-dev python-pip
		pip2 install neovim
		python3.7 -m pip install neovim
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
		sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
	fi
}

install_ag() {
	if ! command_exists ag; then
		echo "ag not found. Installing..."
		sudo apt -q install 'silversearcher-ag'
	fi
}

install_fzf() {
	if ! command_exists fzf; then
		echo "fzf not found. Installing..."
		git clone --depth 1 git@github.com:junegunn/fzf.git
		chmod +x fzf/install
		./fzf/install
	fi
}

install_virtualenvwrapper() {
	if ! command_exists virtualenvwrapper.sh; then
		echo "virtualenvwrapper not found. Installing..."
		python3.7 -m pip install virtualenvwrapper
	fi
}

install_poetry() {
	if ! command_exists poetry; then
		echo "poetry not found. Installing..."
		curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
	fi
}

install_npm() {
	if ! command_exists npm; then
		echo "npm not found. Installing..."
		sudo apt install npm
		sudo npm install -g npm@latest
		sudo npm install -g typescript webpack util @types/node
	fi
}

install_fd() {
	if ! command_exists fd; then
		echo "fd not found. Installing..."
		local file="fd-musl_7.3.0_amd64.deb"
		wget https://github.com/sharkdp/fd/releases/download/v7.3.0/${file}
		sudo dpkg -i ${file}
	fi
}

install_prezto() {
	if [[ ! -d ~/.zprezto ]]; then
		echo "Prezto not found. Installing..."
		git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	fi
}

install_tpm() {
	if [[ ! -d ~/.tmux/plugins/tpm ]]; then
		echo "TPM not found. Installing..."
		mkdir -p ~/.tmux/plugins > /dev/null 2>&1
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi
}

install_docker() {
	sudo apt install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"

	sudo apt-get install docker-ce docker-ce-cli containerd.io

	sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

	sudo chmod +x /usr/local/bin/docker-compose

	if ! grep -q docker /etc/group; then
		sudo groupadd docker
	fi

	sudo usermod -aG docker $USER
}

cd "${_root}"

install_git
install_curl
install_fonts
install_tmux
install_zsh
install_neovim
install_ag
install_fzf
install_python3
install_virtualenvwrapper
install_poetry
install_npm
install_fd
install_prezto
install_tpm
install_docker
install_jump
install_jdk


_files=(ideavimrc flake8 gitconfig gitignore_global pylintrc pythonrc tmux-macosx tmux.conf vimrc zpreztorc zprofile zshenv zshrc)

echo "${_files[@]}"
for file in "${_files[@]}"; do
	echo "Linking "${_dir}/${file}" to ${HOME}/.${file}"
	if [[ "${file}" == "vimrc" ]]; then
		mkdir -p ~/.config/nvim > /dev/null 2>&1
		ln -s -f "${_dir}/${file}" "${HOME}/.config/nvim/init.vim"
	elif [[ "${file}" =~ "flake8" ]]; then
		mkdir ~/.config > /dev/null 2>&1
		ln -s -f "${_dir}/${file}" "${HOME}/.config/flake8"
	else
		ln -s -f "${_dir}/${file}" "${HOME}/.${file}"
	fi
done
if ! cat ~/.zshenv | grep -q 'DOT_FILES='; then
	echo "export DOT_FILES=${DOT_FILES}" >> "${HOME}/.zshenv"
fi

if [[ ! -d ~/.vim/config ]]; then
	echo "Linking vim configs"
	mkdir -p ~/.vim > /dev/null 2>&1
	ln -s -f ${_dir}/vim/config ~/.vim/config
fi
