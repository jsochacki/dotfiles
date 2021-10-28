#!/bin/bash

# To build vim with literally all features use this
# Note you already have these all and these will mess up the versions you have so DON"T run this in your scripts
# it is just for information completeness
#sudo apt-get install -y python3 g++ make

# Get Vim (needed Python 3 all set up first sadly for vim build to support ultisnips)
curl https://nodejs.org/dist/v16.13.0/node-v16.13.0.tar.gz --output nodejs
cd nodejs
./configure
make -j8
sudo make install
cd ../
rm -rf nodejs
sudo update-alternatives --install /usr/bin/nodejs nodejs /usr/local/bin/nodejs 1
sudo update-alternatives --set nodejs /usr/local/bin/nodejs
