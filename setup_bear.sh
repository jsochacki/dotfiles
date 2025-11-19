#!/bin/bash

# NOTE
# Bear is only for one liners really, to get the database with cmake projects
# just do cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON to get compile_commands.json
# The same is available from ninja and other build tools as well

sudo apt-get install -y pkg-config libfmt-dev libspdlog-dev nlohmann-json3-dev \
                libgrpc++-dev protobuf-compiler-grpc libssl-dev

git clone https://github.com/rizsotto/Bear.git
cd Bear

cmake -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DENABLE_UNIT_TESTS=OFF -DENABLE_MULTILIB=ON -DENABLE_FUNC_TESTS=OFF .
make all -j$(nproc)
sudo make install

cd ..
rm -rf Bear
