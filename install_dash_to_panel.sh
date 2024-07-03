#!/bin/bash

#-- Create Temporary Folder ------------------------------------
declare folder_name="$RANDOM-dash-to-panel";
declare folder_path="/tmp/$folder_name"

mkdir "$folder_path";
cd "$folder_path";

#-- Download Source Code ------------------------------------
sudo apt install git -y;
git clone "https://github.com/home-sweet-gnome/dash-to-panel.git";
cd "dash-to-panel/";

#-- Install Dependencies  ------------------------------------
sudo apt install gettext -y;
sudo apt install make -y;

#-- Install Extension ------------------------------------
make install;
gnome-extensions enable "dash-to-panel@jderose9.github.com";
busctl --user call "org.gnome.Shell" "/org/gnome/Shell" "org.gnome.Shell" "Eval" "s" 'Meta.restart("Restarting…")';

#-- Remove Temporary Folder ------------------------------------
rm -rf "$folder_path";
