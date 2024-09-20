#!/bin/bash

TMPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
homedir=$(pwd)
cd $TMPDIR

sudo apt update
sudo apt-get purge -y golang-go golang-1.18-go

sudo wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
sudo tar -C /opt -xzf go1.22.5.linux-amd64.tar.gz

echo '' >> $homedir/.bashrc
echo '# Adding go environment variables' >> $homedir/.bashrc
echo 'export PATH="/opt/go/bin:$PATH"' >> $homedir/.bashrc
echo 'export GOROOT=/opt/go' >> $homedir/.bashrc
echo 'export GOPATH=$HOME/go' >> $homedir/.bashrc

sudo rm go1.22.5.linux-amd64.tar.gz

