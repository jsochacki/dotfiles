#!/bin/bash


echo "Installing CUDA 11.1"

echo "Installing Dependencies"

sudo apt-get -y install g++ freeglut3-dev build-essential libx11-dev \
    libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
    
echo "Downloading the file"

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda-repo-ubuntu2004-11-1-local_11.1.0-455.23.05-1_amd64.deb

echo "Installing the Toolkit"

sudo dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.0-455.23.05-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

sudo rm cuda-repo-ubuntu2004-11-1-local_11.1.0-455.23.05-1_amd64.deb

echo "Setting up links and bashrc"

sudo ln -s /usr/local/cuda-11.1 /usr/local/cuda

echo "" >> ~/.bashrc
echo "# Adding Path For CUDA" >> ~/.bashrc
echo 'export PATH="/usr/local/cuda/bin${PATH:+:${PATH}}"' >> ~/.bashrc
echo 'export CUDADIR="/usr/local/cuda"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"' >> ~/.bashrc

echo "Install Complete"
