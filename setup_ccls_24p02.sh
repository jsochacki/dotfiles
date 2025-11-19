#!/bin/bash

sudo apt-get purge -y llvm-10
sudo apt-get install -y curl libssl-dev libcurl4-openssl-dev libzstd-dev clang libclang-dev libclang-18-dev libedit-dev llvm-18

git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

cmake -S. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-18 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-18/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-18/

cmake --build Release
cd Release && sudo make install

cd ../..
rm -rf ccls
