#!/bin/bash

wget https://github.com/home-sweet-gnome/dash-to-panel/releases/download/v56/dash-to-panel@jderose9.github.com_v56.zip
gnome-extensions install dash-to-panel@jderose9.github.com_v56.zip
rm -rf dash-to-panel@jderose9.github.com_v56.zip
echo "DONT FORGET TO LOAD YOUR dash-to-panel-config FILE!!!!"
