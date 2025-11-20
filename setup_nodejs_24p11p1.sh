#!/bin/bash

# To build vim with literally all features use this
# Note you already have these all and these will mess up the versions you have so DON"T run this in your scripts
# it is just for information completeness
#sudo apt-get install -y python3 g++ make

# Get Vim (needed Python 3 all set up first sadly for vim build to support ultisnips)
curl https://nodejs.org/dist/v24.11.1/node-v24.11.1.tar.gz --output node
tar -xvf node
cd node-v24.11.1
./configure
make -j8
sudo make install
cd ../
rm -rf node
rm -rf node-v24.11.1
