#!  /usr/bin/env bash

set -ue # exit on usage of undeclared variables
# set -x # debug

_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_file="${_dir}/$(basename "${BASH_SOURCE[0]}")"
_base="$(basename ${_file} .sh)"
_root="${HOME}"

command_exists() {
  type "$1" &>/dev/null
}

install_git() {
  if ! command_exists git; then
    echo "Git not found. Installing..."
    command_exists apt && sudo apt -q install git
    command_exists pacman && sudo pacman -qS --noconfirm git
  fi
}

install_curl() {
  if ! command_exists curl; then
    echo "curl not found. Installing..."
    command_exists apt && sudo apt -q install curl
    command_exists pacman && sudo pacman -qS --noconfirm curl
  fi
}

install_fonts() {
  if ! ls ~/.local/share/fonts 2>/dev/null | grep -qi 'source code'; then
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
    command_exists apt && sudo apt -q install zsh
    command_exists pacman && sudo pacman -qS --noconfirm zsh
    chsh -s $(which zsh)
    command_exists apt && sudo apt -q install shellcheck
  fi
}

install_jump() {
  if ! command_exists jump; then
    if command_exists dpkg; then
      echo "jump not found. Installing..."
      wget https://github.com/gsamokovarov/jump/releases/download/v0.22.0/jump_0.22.0_amd64.deb
      type dpkg && sudo dpkg -i jump_0.22.0_amd64.deb
    fi
  fi
}

install_neovim() {
  if ! command_exists nvim; then
    echo "NeoVim not found. Installing..."

    if command_exists apt; then
      sudo apt -q install neovim

      sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
      sudo update-alternatives --config vi
      sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
      sudo update-alternatives --config vim
      sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
      sudo update-alternatives --config editor
    fi
    command_exists pacman && sudo pacman -qS --noconfirm neovim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkvirtualenv --python python3 nvimpy3
    ~/.virtualenvs/nvimpy3/bin/python -m pip install neovim jedi pylint black isort python-language-server
    nvim -c 'PlugInstall | qa!'
  fi
}

install_tmux() {
  if ! command_exists tmux; then
    echo "Tmux not found. Installing..."
    command_exists apt && sudo apt -q install tmux
    command_exists pacman && sudo pacman -qS --noconfirm tmux
  fi
}

install_python() {
  if ! command_exists python3 || ! command_exists pip; then
    echo "python3 not found. Installing..."
    if command_exists apt; then
      sudo apt -q install python3 python3-dev python3-pip

      if command_exists python2.7; then
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
      else
        sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
      fi
    elif command_exists pacman; then
      sudo pacman -qS --noconfirm python python-pip python2 python2-pip
    fi
  fi
}

install_pyenv() {
  if ! command_exists pyenv; then
    PYTHON_VERSION=3.13.1
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    if command_exists apt; then
      sudo apt-get install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev
    fi
    pyenv install $PYTHON_VERSION
    pyenv global $PYTHON_VERSION
  fi
}

install_ag() {
  if ! command_exists ag; then
    echo "ag not found. Installing..."
    command_exists apt && sudo apt -q install 'silversearcher-ag'
    command_exists pacman && sudo pacman -qS --noconfirm the_silver_searcher
  fi
}

install_fzf() {
  if ! command_exists fzf && [ ! -d ~/fzf ]; then
    echo "fzf not found. Installing..."
    cd $HOME
    git clone --depth 1 https://github.com/junegunn/fzf.git
    chmod +x fzf/install
    ./fzf/install
    mkdir -p ~/.local/bin/
    ln -s ~/fzf/bin/fzf ~/.local/bin/fzf
    cd -
  fi
}

install_virtualenvwrapper() {
  if ! command_exists virtualenvwrapper.sh; then
    echo "virtualenvwrapper not found. Installing..."
    sudo python3 -m pip install virtualenvwrapper
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
    command_exists apt && sudo apt -q install node npm
    command_exists pacman && sudo pacman -qS --noconfirm npm
    sudo npm install -g typescript webpack util @types/node
    sudo npm install -g prettier
    sudo npm install -g --save-dev prettier @prettier/plugin-xml
  fi
}

install_fd() {
  if ! command_exists fd && ! command_exists fdfind; then
    echo "fd not found. Installing..."
    command_exists apt && sudo apt -q install fd-find
    command_exists pacman && pacman -qS --noconfirm fd
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
    mkdir -p ~/.tmux/plugins >/dev/null 2>&1
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

install_sdk() {
  if ! [ -d ~/.sdkman ]; then
    if ! command_exists unzip; then
      sudo apt install unzip
    fi
    if ! command_exists zip; then
      sudo apt install zip
    fi
    echo "SDKMAN! not found. Installing..."
    curl -s "https://get.sdkman.io" | bash
  fi
}

install_dev() {
  if ! command_exists java; then
    set +u
    . "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java
    sdk install kotlin
    sdk install gradle
    sdk install maven
    set -u
  fi
}

install_docker() {
  if command_exists apt; then
    sudo apt -q install \
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
  fi
}

install_rg() {
  if ! command_exists rg; then
    sudo apt-get install ripgrep
  fi
}

install_bat() {
  if ! command_exists bat && ! command_exists batcat; then
    sudo apt-get install bat
    sudo update-alternatives --install /usr/bin/bat bat /usr/bin/batcat 60
  fi
}

cd "${_root}"

install_git
install_curl
install_fonts
install_tmux
install_zsh
install_pyenv
install_neovim
install_fzf
install_npm
install_fd
install_tpm
# install_docker
install_jump
install_sdk
install_dev
install_bat
install_rg
