#!/bin/bash

#Not safe
#homedir=$(eval echo ~$USER)
#Prevents errors due to sudo run setting USER as root
TMPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd
homedir=$(pwd)
cd $TMPDIR

function_apt_wait_for_unlock () {
  while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 5
  done
  while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
    sleep 5
  done
  while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
    sleep 5
  done
  if [ -f /var/log/unattended-upgrades/unattended-upgrades.log ]; then
    while sudo fuser /var/log/unattended-upgrades/unattended-upgrades.log >/dev/null 2>&1 ; do
      sleep 5
    done
  fi
  $@
}

# Inkscape fails to install if you don't
function_apt_wait_for_unlock sudo apt-get update -y

# Need to get X display server starter for i3
function_apt_wait_for_unlock sudo apt install -y xinit

# Get git, curl, and make
function_apt_wait_for_unlock sudo apt-get install -y git curl make

# Get Cpp development dependencies (note make is part of build-essential)
function_apt_wait_for_unlock sudo apt-get install -y build-essential clang-format

# you need to run this from the git directory

function_apt_wait_for_unlock ./install_and_setup_texlive.sh

# Get window managers and window management utilities
function_apt_wait_for_unlock sudo apt-get install -y tmux bspwm i3 feh
function_apt_wait_for_unlock sudo apt-get install -y rxvt-unicode
# https://i3wm.org/docs/userguide.html

# Get PDF Viewer
function_apt_wait_for_unlock sudo apt-get install -y zathura zathura-pdf-poppler

# Get latex compiler for vimtex
function_apt_wait_for_unlock sudo apt-get install -y latexmk xzdec
# Get for forward searching in zatuhura with vimtex
function_apt_wait_for_unlock sudo apt-get install -y xdotool
# Get inkscape for non diagram figures and prefent "Failed to load module "canberra-gtk-module"" error
function_apt_wait_for_unlock sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module
# The other option is inkscape=0.92.5-1ubuntu1 but i believe 1.1 is the one all
# of this was developed around
# function_apt_wait_for_unlock sudo apt-get install -y inkscape=0.92.5-1ubuntu1.1
# Note this wont work with your whole setup scheme as it has a whole new SVG creation issue
# but i dont have time to deal with it now so come back and figure this out in the future
# how to get an old and good version
function_apt_wait_for_unlock sudo apt-get install -y inkscape
# Need these to support automated vimtex inkscape interaction
#function_apt_wait_for_unlock sudo apt-get install -y python3.8-dev rofi python3-pip

echo '' >> $homedir/.bashrc
echo '# Adding path for latex helpers' >> $homedir/.bashrc
echo 'export PATH="'$homedir'/.local/bin:$PATH"' >> $homedir/.bashrc

#Do now so you can finish setup without leaving the script
export PATH=$homedir/.local/bin:$PATH

function_apt_wait_for_unlock sudo apt-get install -y pipx

# Finally install
cd
git clone https://github.com/jsochacki/inkscape-latex-figures.git
cd inkscape-latex-figures
#pip3.8 install --user .
pipx install .
cd ../
rm -rf inkscape-latex-figures

# Install the python version i made for diagrams.net images
git clone https://github.com/jsochacki/diagrams-net-figures.git
cd diagrams-net-figures
#pip3.8 install --user .
pipx install .
cd ../
rm -rf diagrams-net-figures

#inkscape shortcut manager setup
function_apt_wait_for_unlock sudo apt-get install -y python3-xlib

# Just clone from mine instead
#cd $homedir/.local/lib/python3.8/site-packages/
cd $homedir/.local/lib/python3.10/site-packages/
git clone https://github.com/jsochacki/inkscape-latex-shortcuts.git

# Get vim-plug and set it up
curl -fLo $homedir/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

function_apt_wait_for_unlock sudo apt-get install -y xclip pdf2svg
# It isn't in his list but you need urxvt to use text insertion etc...
#function_apt_wait_for_unlock sudo apt-get install -y rxvt
# I already get it though for i3 so we are good


cd $TMPDIR
#"install" my script and files
ln -s $TMPDIR/update_tex_figures.sh $homedir/.local/bin/update_tex_figures.sh
ln -s $TMPDIR/make_gnuplots.sh $homedir/.local/bin/make_gnuplots.sh
ln -s $TMPDIR/run_pandoc_commands.sh $homedir/.local/bin/run_pandoc_commands.sh
ln -s $TMPDIR/run_doxygen_commands.sh $homedir/.local/bin/run_doxygen_commands.sh
ln -s $TMPDIR/run_cmake_commands.sh $homedir/.local/bin/run_cmake_commands.sh
ln -s $TMPDIR/make_venv_here.sh $homedir/.local/bin/make_venv_here.sh
#cp update_tex_figures.sh $homedir/.local/bin/update_tex_figures.sh

# Do some vimrc setup
mkdir -p $homedir/.vim/spell
ln -s $TMPDIR/.vimrc.plugged $homedir/
ln -s $TMPDIR/.vimrc.normal $homedir/
ln -s $TMPDIR/.vimrc.colors $homedir/
ln -s $TMPDIR/.vimrc.custom $homedir/
ln -s $TMPDIR/.vimrc $homedir/
ln -sf $TMPDIR/en.utf-8.add $homedir/.vim/spell/
#cp .vimrc.plugged $homedir/
#cp .vimrc.normal $homedir/
#cp .vimrc.colors $homedir/
#cp .vimrc.custom $homedir/
#cp .vimrc $homedir/

# Do tmux setup
ln -s $TMPDIR/.tmux.conf $homedir/

# Do some filetype specific setup
mkdir -p  $homedir/.vim/ftplugin/
ln -s $TMPDIR/c.vim $homedir/.vim/ftplugin/
ln -s $TMPDIR/python.vim $homedir/.vim/ftplugin/
ln -s $TMPDIR/tex.vim $homedir/.vim/ftplugin/
ln -s $TMPDIR/markdown.vim $homedir/.vim/ftplugin/
ln -s $TMPDIR/matlab.vim $homedir/.vim/ftplugin/
#cp c.vim $homedir/.vim/ftplugin/
#cp python.vim $homedir/.vim/ftplugin/
#cp tex.vim $homedir/.vim/ftplugin/
#cp markdown.vim $homedir/.vim/ftplugin/

# Do some non vimrc setup
mkdir -p $homedir/.vim/UltiSnips
ln -s $TMPDIR/tex.snippets $homedir/.vim/UltiSnips/
ln -s $TMPDIR/markdown.snippets $homedir/.vim/UltiSnips/
ln -s $TMPDIR/cpp.snippets $homedir/.vim/UltiSnips/
ln -s $TMPDIR/c.snippets $homedir/.vim/UltiSnips/
ln -s $TMPDIR/cu.snippets $homedir/.vim/UltiSnips/
ln -s $TMPDIR/matlab.snippets $homedir/.vim/UltiSnips/
#cp tex.snippets $homedir/.vim/UltiSnips/
#cp cpp.snippets $homedir/.vim/UltiSnips/
#cp c.snippets $homedir/.vim/UltiSnips/
#cp cu.snippets $homedir/.vim/UltiSnips/


# Install vim, you need to wait until python 3 is setup as we compile with
# python 3
function_apt_wait_for_unlock ./setup_vim.sh

#Manual youcompletemeinstall if plug doesn't work which it shouldnt
function_apt_wait_for_unlock ./install_and_setup_youcompleteme.sh

# Add matlab syntax file in case you decide to install matlab
mkdir -p $homedir/.vim/syntax
ln -s $TMPDIR/mymatlab.vim $homedir/.vim/syntax/

# Copy over scripts and config files
mkdir -p $homedir/.local/bin
ln -s $TMPDIR/myclang-format.py3 $homedir/.local/bin/clang-format.py
ln -s $TMPDIR/.clang-format $homedir/
#cp myclang-format.py3 $homedir/.local/bin/clang-format.py
#cp .clang-format $homedir/
mkdir -p $homedir/.config/zathura/
ln -s $TMPDIR/zathurarc $homedir/.config/zathura/
#cp zathurarc $homedir/.config/zathura/
mkdir -p $homedir/.config/i3/
ln -s $TMPDIR/i3config $homedir/.config/i3/config
ln -s $TMPDIR/.Xresources $homedir/
#cp i3config $homedir/.config/i3/config
#cp .Xresources $homedir/
mkdir -p $homedir/.cfiles
ln -s $TMPDIR/c.ycm_extra_conf.py $homedir/.cfiles/.ycm_extra_conf.py
#cp c.ycm_extra_conf.py $homedir/.cfiles/.ycm_extra_conf.py
mkdir -p $homedir/.pyfiles
ln -s $TMPDIR/py.ycm_extra_conf.py $homedir/.pyfiles/.ycm_extra_conf.py
#cp py.ycm_extra_conf.py $homedir/.pyfiles/.ycm_extra_conf.py
# Dont actually need to do this below to get urxvt settings to take
#echo 'xrdb $homedir/.Xresources' >> $homedir/.xinitrc
mkdir -p $homedir/.vimfiles

# Setup auto google
ln -s $TMPDIR/Googleit.py $homedir/.cfiles/
#cp Googleit.py $homedir/.cfiles/
chmod guo+x $homedir/.cfiles/Googleit.py
ln -s $homedir/.cfiles/Googleit.py $homedir/.pyfiles/
ln -s $homedir/.cfiles/Googleit.py $homedir/.vimfiles/
#cp $homedir/.cfiles/Googleit.py $homedir/.pyfiles/
#cp $homedir/.cfiles/Googleit.py $homedir/.vimfiles/

# Opens vim, installs the plugins, then quits back to shell
vim +PlugInstall +qa


mkdir -p $homedir/Pictures
mkdir -p $homedir/Snips

# Get backgrounds
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter1.jpg http://wallpaperim.net/_data/i/upload/2014/09/23/20140923661374-3acd5e08-me.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter2.jpg https://cache.desktopnexus.com/wallpapers/391/391188-1920x1080-beautiful-winter-landscape-1920x1080-wallpaper-568.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter3.jpg http://www.bhmpics.com/walls/dead_snow_winter-other.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter4.jpg https://wallpapercave.com/wp/0sCOQyE.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter5.jpg https://wallpapercave.com/wp/mc5kprj.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter6.jpg https://wallpapercave.com/wp/jNHBSir.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter7.jpg https://images.alphacoders.com/727/727275.png
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter8.jpg https://images.unsplash.com/photo-1482358625854-d7d631ba1858?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80
#wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter9.jpg http://www.wallpaperstop.com/wallpapers/nature-wallpapers/winter-wallpapers/winter-candle-1920x1200-164125.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter9.jpg https://wallpaperaccess.com/full/865840.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter10.jpg http://wallpaperswide.com/download/winter_cat-wallpaper-1920x1080.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter11.jpg https://images4.alphacoders.com/184/thumb-1920-184306.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter12.jpg https://images5.alphacoders.com/354/thumb-1920-354500.jpg
#wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter13.jpg https://latestwallpapershd.com/wp-content/uploads/2019/03/Beautiful-winter-wallpaper-HD.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter13.jpg https://wallpaperaccess.com/full/1320394.jpg
#wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter14.jpg https://animal-wallpaper.com/wallpaper/winter-wallpaper-desktop-background-For-Background-HD-Wallpaper.jpg
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $homedir/Pictures/winter14.jpg https://wallpaperaccess.com/full/965543.jpg


# Install a decent browser
function_apt_wait_for_unlock ./Chrome_Setup.sh
# to later tweak gnome
sudo apt-get install chrome-gnome-shell

# Install pandoc
wget https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-linux-amd64.tar.gz
# strip-componenets means instead of /usr/local/pandoc/bin/* and /usr/local/pandoc/share/* will
# infact and instead land in /usr/local/bin and /usr/local/share
sudo tar xvzf pandoc-2.11.2-linux-amd64.tar.gz --strip-components 1 -C /usr/local/
rm pandoc-2.11.2-linux-amd64.tar.gz

# install diagrams.net
# Version matters and must be 14.1.8
#sudo snap install drawio --devmode
# Cant snap install anymore as version 15 breaks everything and this was all
# based around version 14.1.8 so we need to manually install that now
# COME BACK AND DEAL WITH LATER WHEN THE REST IS WORKING AND YOU FIX INKSCAPE AS WELL
#wget https://github.com/jgraph/drawio-desktop/releases/download/v14.1.8/draw.io-amd64-14.1.8.deb
#sudo dpkg -i draw.io-amd64-14.1.8.deb
#rm draw.io-amd64-14.1.8.deb
# for now just get the snap version as it is up to date far more than the deb version
# you need devmode to be able to open files on removable media due to mpn
# permissions
sudo snap install drawio --devmode

# Install Libre office
function_apt_wait_for_unlock sudo apt-get install -y libreoffice libreoffice-numbertext libreoffice-ogltrans libreoffice-writer2latex libreoffice-writer2xhtml

# Install a rastered image editor since all you have is vector editors currently
# Kolourpaint is better imo
#snap install pinta
sudo apt-get install kolourpaint


# Get Data Grabbing Tools
wget https://www.digitizeit.de/downloads/DigitizeIt_unix.zip
unzip DigitizeIt_unix.zip -x __*
chmod ugo+x DigitizeIt_unix/DigitizeIt.jar
sudo mv DigitizeIt_unix /opt/digitizelt
rm DigitizeIt_unix.zip

wget https://www.datathief.org/Datathief.jar
chmod ugo+x Datathief.jar
sudo mkdir -p /opt/datathiefIII
sudo mv Datathief.jar /opt/datathiefIII/

# Add Data Grabbing Tools To Path
echo '' >> $homedir/.bashrc
echo '# Adding path for Data Grabbing Tools' >> $homedir/.bashrc
echo 'export PATH="/opt/datathiefIII:/opt/digitizelt:$PATH"' >> $homedir/.bashrc

#Do now so you can finish setup without leaving the script
export PATH=/opt/datathiefIII:/opt/digitizelt:$PATH


# Install gnuplot
function_apt_wait_for_unlock sudo apt-get install -y gnuplot

# Get sshfs for remote development using local system (mounts remotes filesystem locally)
function_apt_wait_for_unlock sudo apt-get install -y sshfs

# Make it so ImageMagic Can turn pdf and PS files into png files
IMGMGK_FULLPATH=$(sudo find /etc/ -name 'ImageMagick*')
IMGMGK_POLICY_FULLFILE="$IMGMGK_FULLPATH/policy.xml"
if [ -f "$IMGMGK_POLICY_FULLFILE" ];
then
   sudo sed -i 's@<policy domain="coder" rights="none" pattern="PS" />@<policy domain="coder" rights="read | write" pattern="PS" />@' $IMGMGK_POLICY_FULLFILE
   sudo sed -i 's@<policy domain="coder" rights="none" pattern="PDF" />@<policy domain="coder" rights="read | write" pattern="PDF" />@' $IMGMGK_POLICY_FULLFILE
fi


# Launch i3 on startup
echo '' >> $homedir/.bashrc
echo '# Adding i3 autolaunch' >> $homedir/.bashrc
echo 'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then' >> $homedir/.bashrc
echo '   startx' >> $homedir/.bashrc
echo 'fi' >> $homedir/.bashrc


# Install gsl
function_apt_wait_for_unlock ./install_gsl.sh

# Install doxygen
function_apt_wait_for_unlock ./install_doxygen.sh

# Install mermaid and mermaid-cli for system and mermaid-filter for pandoc
# Need to get newer version of Node.js first
function_apt_wait_for_unlock ./setup_nodejs_22p4p0.sh
#function_apt_wait_for_unlock sudo npm install -g npm@8.1.1 to update
function_apt_wait_for_unlock sudo npm install -g npm
function_apt_wait_for_unlock sudo npm install -g mermaid
function_apt_wait_for_unlock sudo npm install -g mermaid-filter
function_apt_wait_for_unlock sudo npm install -g mermaid-cli
function_apt_wait_for_unlock sudo npm install -g mermaid.cli


# Install git-lfs
function_apt_wait_for_unlock sudo apt-get install -y git-lfs

# git libfuse for appimage support
function_apt_wait_for_unlock sudo apt-get install -y libfuse2

# Add openvpn script
cd $TMPDIR
ln -s $TMPDIR/start_openvpn_lsi.sh $homedir/.local/bin/start_openvpn_lsi.sh

# Install tailscale and run it on status
curl -fsSL https://tailscale.com/install.sh | sh
echo '' >> $homedir/.bashrc
echo '# Adding tailscale autolaunch' >> $homedir/.bashrc
echo 'sudo tailscale up' >> $homedir/.bashrc
cd $TMPDIR
ln -s $TMPDIR/tailscale_resolve_dns.sh $homedir/.local/bin/tailscale_resolve_dns.sh

# Add VPN shutdown script so it doesnt stay up on shutdown OR reboot
function_apt_wait_for_unlock sudo ln -s $TMPDIR/K02tailscale_down /etc/rc0.d/K02tailscale_down
function_apt_wait_for_unlock sudo ln -s $TMPDIR/K02tailscale_down /etc/rc6.d/K02tailscale_down

# Add bitwarden
sudo snap install bitwarden
sudo snap install bw

# Install slack, wire, element-desktop, and signal-desktop
function_apt_wait_for_unlock ./setup_chat_apps.sh

# Get and install obsidian
cd $TMPDIR
sudo snap install obsidian --classic

# Get python 3 venv and set it up for common use
function_apt_wait_for_unlock sudo apt-get install -y python3.12-venv

# Add to dialout for hardware access
sudo usermod -aG dialout $USER
newgrp dialout
cat 
# Allow docker containers to connect to the host X11 server
echo '' >> $homedir/.bashrc
echo '# Allow docker containers to connect to the host X11 server' >> $homedir/.bashrc
echo 'xhost +local:docker' >> $homedir/.bashrc

# Dont let there be swap, ever
sudo swapoff -a

# Add ms fonts
function_apt_wait_for_unlock sudo add-apt-repository -y multiverse
function_apt_wait_for_unlock sudo apt update -y
function_apt_wait_for_unlock sudo apt-get install -y ttf-mscorefonts-installer
function_apt_wait_for_unlock sudo fc-cache -f -v

# Add 7zip
cd $TMPDIR
sudo rm -rf /opt/7zip
sudo mkdir -p /opt/7zip
wget --timeout=1 --waitretry=0 --tries=5 --retry-connrefused -O $TMPDIR/7zip.tar.xz https://www.7-zip.org/a/7z2407-linux-x64.tar.xz
sudo tar -xvf 7zip.tar.xz --directory /opt/7zip
sudo rm 7zip.tar.xz
echo '' >> $homedir/.bashrc
echo '# path for 7zip' >> $homedir/.bashrc
echo 'export PATH="/opt/7zip:$PATH"' >> $homedir/.bashrc

#Do now so you can finish setup without leaving the script
export PATH=/opt/7zip:$PATH

#Install a terminal emulator
function_apt_wait_for_unlock sudo apt-get install -y screen

# Install cifs-utils so you can mount smb drives
function_apt_wait_for_unlock sudo apt-get install -y cifs-utils
# sudo mount -t cifs //IP/share_name /mnt/NAS -o username=uname,domain=domainname

# Setup go
function_apt_wait_for_unlock ./setup_go.sh

# Setup Saleae
function_apt_wait_for_unlock ./setup_saleae.sh

# Add matlab desktop icon if installing matlab
sudo cp matlab.desktop /usr/share/applications/

# Get coolkey for pki certs
function_apt_wait_for_unlock sudo apt-get install -y coolkey

#Fix Ubuntu Toolbar
function_apt_wait_for_unlock ./install_dash_to_panel.sh

# Do at the end as causes shell issues with newgrp docker
# Install docker, ansible, TODO k3s, 
function_apt_wait_for_unlock ./setup_docker.sh
function_apt_wait_for_unlock ./setup_ansible.sh

# Do VMWARE specific setup at the end
function_apt_wait_for_unlock ./setup_vmware_clipboard.sh
function_apt_wait_for_unlock ./setup_vmware_share.sh

source $homedir/.bashrc
