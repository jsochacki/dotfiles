#!/bin/bash

wget https://github.com/home-sweet-gnome/dash-to-panel/releases/download/v36/dash-to-panel@jderose9.github.com_v36.zip
gnome-extensions install dash-to-panel@jderose9.github.com_v36.zip
rm -rf dash-to-panel@jderose9.github.com_v36.zip
echo "DONT FORGET TO LOAD YOUR dash-to-panel-config FILE!!!!"
