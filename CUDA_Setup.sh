#!/bin/bash

sdkversion=CUDA10p1

echo "Installing CUDA 10.0"

echo "Installing Dependencies"

sudo apt-get -y install freeglut3 freeglut3-dev libxi-dev libxmu-dev

echo "Downloading the file"

wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.168-418.67_1.0-1_amd64.deb

sudo dpkg -i cuda-repo-ubuntu1804-10-1-local-10.1.168-418.67_1.0-1_amd64.deb

echo "Installing the Toolkit"

sudo apt-key add /var/cuda-repo-10-1-local-10.1.168-418.67/7fa2af80.pub
sudo apt-get update
sudo apt-get install cuda

sudo rm cuda-repo-ubuntu1804-10-1-local-10.1.168-418.67_1.0-1_amd64.deb

echo "Setting up bashrc"

echo "" >> ~/.bashrc
echo "# Adding Path For CUDA" >> ~/.bashrc
echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
echo 'export CUDADIR="/usr/local/cuda"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"' >> ~/.bashrc

echo "Install Complete"
