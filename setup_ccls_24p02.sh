#!/bin/bash

sudo apt-get install clang libclang-18-dev

git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

cmake -S. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-14 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-14/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-14/

cmake --build Release
cd Release && sudo make install

cd ../..
rm -rf ccls
