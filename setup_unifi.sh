#!/bin/bash

sudo apt-get update
sudo apt-get install ca-certificates curl -y
curl -sO https://get.glennr.nl/unifi/install/install_latest/unifi-latest.sh
sudo unifi-latest.sh

