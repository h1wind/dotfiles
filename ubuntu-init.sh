#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y cmake gcc g++ make git \
	gdb python3 python3-pip wget curl golang clangd clang-format gopls nodejs npm ripgrep

python3 -m pip install cmake-language-server python-lsp-server autopep8
npm install -g typescript typescript-language-server vscode-langservers-extracted

mkdir -p $HOME/.local
mkdir -p $HOME/.config

cd $HOME/.local

wget https://github.com/neovim/neovim/releases/download/v0.6.1/nvim-linux64.tar.gz

tar xf nvim-linux64.tar.gz
mv nvim-linux64/* ./
rm -rf nvim-linux64 nvim-linux64.tar.gz

echo "export PATH=\"\$HOME:\$PATH\"" >> $HOME/.bashrc

cd $HOME

git clone https://github.com/h1zzz/dotfiles.git
mv dotfiles/nvim $HOME/.config

rm -rf dotfiles
