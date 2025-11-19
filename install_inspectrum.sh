#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y qtbase5-dev libfftw3-dev cmake pkg-config libliquid-dev 
sudo apt-get install -y build-essential git
git clone https://github.com/miek/inspectrum.git

pushd inspectrum/

mkdir build

pushd build/

cmake ..
make -j$(nproc)
sudo make install

popd
popd

rm -rf inspectrum

