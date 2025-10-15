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

install_neovim() {
  if ! command_exists nvim; then
    echo "NeoVim not found. Installing..."

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
  if ! command_exists pyenv; then
    PYTHON_VERSION=3.13.1
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    if command_exists apt; then
      sudo apt -q install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev
    fi
    ~/.pyenv/bin/pyenv install $PYTHON_VERSION
    ~/.pyenv/bin/pyenv global $PYTHON_VERSION

    export PYENV_ROOT="~/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
}

install_fzf() {
  if ! command_exists fzf && [ ! -d ~/fzf ]; then
    echo "fzf not found. Installing..."
    cd ~
    git clone --depth 1 https://github.com/junegunn/fzf.git
    chmod +x fzf/install
    ./fzf/install
    mkdir -p ~/.local/bin/
    ln -s ~/fzf/bin/fzf ~/.local/bin/fzf
    cd -
  fi
}

install_poetry() {
  if ! command_exists poetry; then
    echo "poetry not found. Installing..."
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
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
      sudo apt -q install unzip
    fi
    if ! command_exists zip; then
      sudo apt -q install zip
    fi
    echo "SDKMAN! not found. Installing..."
    curl -s "https://get.sdkman.io" | bash
  fi
}

install_dev() {
  if ! command_exists java; then
    set +u
    . "~/.sdkman/bin/sdkman-init.sh"
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
    sudo apt -q install docker-ce docker-ce-cli containerd.io
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    if ! grep -q docker /etc/group; then
      sudo groupadd docker
    fi
    sudo usermod -aG docker $USER
  fi
}

install_lazygit() {
  if ! command_exists lazygit; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo apt -q install lazygit -D -t /usr/local/bin/
  fi
}

install_rust() {
  if ! command_exists cargo; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ~/.cargo/bin/cargo install cargo-watch
    ~/.cargo/bin/cargo install git-delta
  fi
}

install_zoxide() {
  if ! command_exists z; then
    ~/.cargo/bin/cargo install zoxide
  fi
}

install_rg() {
  if ! command_exists rg; then
    ~/.cargo/bin/cargo install ripgrep
  fi
}

install_bat() {
  if ! command_exists bat && ! command_exists batcat; then
    ~/.cargo/bin/cargo install bat
  fi
}

install_zip() {
  if ! command_exists unzip; then
    sudo apt -q install zip unzip
  fi
}

install_xsel() {
  if ! command_exists xsel; then
    sudo apt -q install xsel
  fi
}

install_nodejs() {
  if ! command_exists npm; then
    sudo apt -q install nodejs npm
  fi
}

cd "${_root}"

install_git
install_lazygit
install_curl
install_fonts
install_tmux
install_zsh
install_python
install_neovim
install_fzf
install_fd
install_tpm
# install_docker
install_jump
install_sdk
# install_dev
install_rust
install_bat
install_rg
install_zip
install_zoxide
install_xsel
install_nodejs
