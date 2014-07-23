#!/bin/bash
# ==========================================================================
# Build script for custom XBMC Debian Package with PS3 Hotplugging
# ==========================================================================
#
# If sucessful, this will be tested against the Xbox 360 controller as well.
# If it can co-exist (the new build), will be used as normal. If it cannot,
# It will be only installed as part of the PS3 gamepad selection
# It may be useful to tee the output to a log file: 
# './build-xbmc | tee log.txt'
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Contribitions: Michael DeGuzis, aka "ProfessorKaos64"
# Date:    20140723
# Version: Patch Level 5
# ==========================================================================

# Starting point is a plain ubuntu install.
# Get and install RetroRig (done via normal install script, posted for science)

###############################################################
# sudo apt-get update
# sudo apt-get install dialog git figlet
# sudo rm /var/cache/apt/archives/*
# cd
# git clone https://github.com/ProfessorKaos64/RetroRig
# cd RetroRig 
# git checkout beta
# sudo ./retrorig_setup.sh
###############################################################

# Instead, add the xbmc PPA manually and do it here so we don't 
# Necessarily need to install a lot of extra stuff to do a new package.
export PL=5
clear
echo "##########################################"
echo "Building new custom xbmc-bin deb pkg"
echo "##########################################"
echo ""
sleep 2s

echo ""
echo "##########################################"
echo "Removing old build files and directories"
echo "##########################################"

# create previous build directory for saving old build files
mkdir -p ~/RetroRig-beforeBuild

# remove xbmc,build dirs, and old files
rm -f build_log.txt
sudo apt-get remove -y xbmc xbmc-bin
# backup old build dirs (ya know, for safety!)
mv -v ~/xbmc ~/RetroRig-beforeBuild
mv -v ~/RetroRig ~/RetroRig-beforeBuild
# Continue to remove old directories
rm -rfv ~/RetroRig
rm -rfv ~/xbmc
sudo rm -rfv /tmp/RetroRig
sudo rm -rfv /tmp/RetroRig-bin/
rm -rfv ~/xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_*.deb
rm -rfv ~/xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_*.deb 

echo ""
echo "##########################################"
echo "Add pre-requisite packages"
echo "##########################################"


sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo apt-get update
sudo apt-get install -y dialog git figlet


echo ""
echo "##########################################"
echo "Extracting old deb packages"
echo "##########################################"

# download original xbmc-bin file for build
mkdir /tmp/RetroRig-bin
cd /tmp/RetroRig-bin
wget "http://www.libregeek.org/RetroRig/old_pkgs/xbmc-bin_original.deb"

# unpack xbmc-bin
sudo dpkg-deb -x xbmc-bin_original.deb .
sudo dpkg-deb -e xbmc-bin_original.deb
# clean packed debs
sudo rm -f *.deb

# download original xbmc file for build
mkdir /tmp/RetroRig
cd /tmp/RetroRig
wget "http://www.libregeek.org/RetroRig/old_pkgs/xbmc_original.deb"

# unpack xbmc
sudo dpkg-deb -x xbmc_original.deb .
sudo dpkg-deb -e xbmc_original.deb
# clean packed debs
sudo rm -f *.deb

#now compile xbmc
cd

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

#apt-get build-deps
sudo apt-get -y build-dep xbmc
#apt-get install packages
sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec1 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev libafpclient-dev libshairplay-dev

echo ""
echo "##########################################"
echo "Fetching beaumanviennas XBMC repository  #"
echo "##########################################"

# clone the xbmc source based on fernetMenta/xbmc and checkout Gotham 13.1 based patch level 
# This XBMC version is used in project OpenElec.
git clone https://github.com/beaumanvienna/xbmc
cd xbmc
git checkout gotham-retrorig-pl$PL
git pull
./bootstrap
./configure --disable-debug --prefix=/usr
echo "Making current pkg"
make -j8

# strip out the bin executable
strip xbmc.bin

#install
sudo make install

echo ""
echo "##########################################"
echo "Creating custom deb pkg"
echo "##########################################"
# replace old xbmc bin file with new one, repack, tidy up
# Notes for dpkg: http://ubuntuforums.org/showthread.php?t=1687348
sudo cp ./xbmc.bin /tmp/RetroRig-bin/usr/lib/xbmc/

# create xbmc-bin
cd /tmp/RetroRig-bin
sudo dpkg-deb -b . xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_$PL.deb
# copy new deb to '/tmp/XBMC_build' dir
mkdir -p /tmp/XBMC_build
cp xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_$PL.deb /tmp/XBMC_build

# create xbmc
cd /tmp/RetroRig
# replace /tmp/RetroRig/user/share/xbmc with /usr/share/xbmc installed by 'sudo make install'
sudo rm -rf /tmp/RetroRig/usr/share/xbmc/
sudo cp -r /usr/share/xbmc/ /tmp/RetroRig/usr/share/

####################################################################
# disbale version check
# Note from pk: this is not necessary in "production"  versions, 
# due to this service being cleanly disabled with the addon pre-set 
# with .retrorig/.xbmc These changes below will stay commented 
# "For Science!"

# uncommented by jc :-P  (14/07/23)
# I had the native xbmc hang upon exit.
#
# If we find some time, we could take care of native xbmc,
# like disabling the version check in the settings or
# setting up controller keymapping. In the meantime I keep the below 
# lines activated.
#
####################################################################

#echo "removing service 'xbmc.versioncheck'"
sudo rm -v /tmp/RetroRig/usr/share/xbmc/addons/service.xbmc.versioncheck/service.py
sudo echo '#!/usr/bin/python' > /tmp/service.py
sudo echo '# service removed' >> /tmp/service.py
sudo mv /tmp/service.py 

#####################################################################

# create package
sudo dpkg-deb -b . xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_$PL.deb
# copy new deb to home dir
cp xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_$PL.deb /tmp/XBMC_build


