#!/bin/bash

CURRENT_DIR=$(pwd)
cd /opt
sudo apt-get install -y ninja-build gettext
sudo apt install -y python3-neovim
pip3 install --user pynvim
sudo npm install -g neovim
#sudo apt-get install -y libuv libluv libutf8proc luajit lua-lpeg tree-sitter tree-sitter-c tree-sitter-lua tree-sitter-markdown tree-sitter-query tree-sitter-vim tree-sitter-vimdoc unibilium
# Need these to build but dont do as you manually build cmake and other things
# already
#sudo apt-get install -y gettext cmake curl build-essential
sudo git clone https://github.com/neovim/neovim
cd neovim
sudo git checkout stable
sudo cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
sudo cmake --build .deps
sudo cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
sudo cmake --build build
sudo make -j$(nproc) CMAKE_BUILD_TYPE=RelWithDebInfo
cd build
sudo cpack -G DEB
sudo dpkg -i nvim-linux64.deb
cd $CURRENT_DIR

