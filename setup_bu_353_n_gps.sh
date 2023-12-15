#!/bin/bash

sudo add-apt-repository -y ppa:opencpn/opencpn
sudo apt update
sudo apt-get install -y opencpn
sudo apt-get install -y gpsd gpsd-clients
sudo usermod -a -G dialout $USER
exit
