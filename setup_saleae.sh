#!/bin/bash

TMPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
homedir=$(pwd)
cd $TMPDIR

mkdir tmp
cd tmp

wget https://downloads.saleae.com/logic2/Logic-2.4.14-linux-x64.AppImage
sudo chmod guo+x Logic-2.4.14-linux-x64.AppImage
sudo ./Logic-2.4.14-linux-x64.AppImage --appimage-extract
sudo mv squashfs-root/ /opt/logic-2

# Define the target file path
target_file="$TMPDIR/tmp/logic-2.desktop"

# Use heredoc to write to the file with sudo privileges
cat <<EOF | sudo tee "$target_file" > /dev/null
[Desktop Entry]
Name=Saleae logic 2
Type=Application
Categories=Utility;
MimeType=image/x-png;
Exec=/opt/logic-2/Logic
Icon=/opt/logic-2/Logic.png
Terminal=false
StartupNotify=true
EOF

# Ensure the file permissions are correct
sudo chmod 777 "$target_file"

sudo desktop-file-install logic-2.desktop

cat /opt/logic-2/resources/linux-x64/99-SaleaeLogic.rules | sudo tee /etc/udev/rules.d/99-SaleaeLogic.rules > /dev/null && echo "finished installing /etc/udev/rules.d/99-SaleaeLogic.rules"

cd ..
sudo rm -rf tmp
