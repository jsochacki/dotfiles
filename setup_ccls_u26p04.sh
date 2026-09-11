#!/bin/bash

LLVM_VER="21"

sudo apt-get install -y curl libssl-dev libcurl4-openssl-dev libzstd-dev clang-${LLVM_VER} libclang-dev libclang-${LLVM_VER}-dev libedit-dev llvm-${LLVM_VER} llvm-${LLVM_VER}-dev

git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

cmake -S. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-${LLVM_VER} \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-${LLVM_VER}/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-${LLVM_VER}/

cmake --build Release
cd Release && sudo make install

cd ../..
rm -rf ccls
