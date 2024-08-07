#!/bin/bash

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo tee /etc/apt/trusted.gpg.d/anydesk-stable.asc
echo 'deb http://deb.anydesk.com/ all main' | sudo tee -a /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt-get install anydesk

