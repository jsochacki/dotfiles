#!/bin/bash

# To build vim with literally all features use this
sudo apt-get install -y libxt-dev ruby-dev mercurial python3-dev libxpm-dev libx11-dev libcairo2-dev libatk1.0-dev
sudo apt-get install -y --allow-downgrades gir1.2-pango-1.0=1.50.6+ds-2 libpango-1.0-0=1.50.6+ds-2 libpangocairo-1.0-0=1.50.6+ds-2 libpangoft2-1.0-0=1.50.6+ds-2 libpangoxft-1.0-0=1.50.6+ds-2 pango1.0-tools=1.50.6+ds-2
sudo apt-get install -y --allow-downgrades gir1.2-gdkpixbuf-2.0=2.42.8+dfsg-1ubuntu0.1 libgdk-pixbuf-2.0-0=2.42.8+dfsg-1ubuntu0.1 libgdk-pixbuf2.0-bin=2.42.8+dfsg-1ubuntu0.1
sudo apt-get install -y libgtk2.0-dev

# Get Vim (needed Python 3 all set up first sadly for vim build to support ultisnips)
sudo apt-get install -y libncurses5-dev libncursesw5-dev build-essential
git clone https://github.com/vim/vim.git
cd vim/src
./configure --with-features=huge --enable-python3interp=yes --with-x
# Build with both
#./configure --with-features=huge --enable-python3interp=yes --enable-gui=auto --with-x
make
sudo make install
cd ../..
rm -rf vim
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 1
sudo update-alternatives  --set vim /usr/local/bin/vim
