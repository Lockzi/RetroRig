#========================================================================
# Build Script for custom dolphin-emu RetroRig PPA
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140908
# Version     : 4.0.0
# Description : Version 4.0.0 from Hunter-Kaller, Patch Level 1
#               
# ========================================================================

#define base version
PRE=3
BASE=4.0.0

# define patch level
PL=1



clear
echo "#################################################################"
echo "Building custom dolphin-emu Debian package (branch $BRANCH)"
echo "#################################################################"
echo ""
if [[ -n "$1" ]]; then

  echo ""
  echo "build target is $1"
  echo ""

else
  echo ""
  echo "build target is source"
  echo ""
fi

sleep 2s

# Fetch build pkgs
if [[ -n "$2" ]]; then

  echo ""
  echo "##########################################"
  echo "Fetching necessary packages for build"
  echo "##########################################"
  echo ""

  # add Glenn Ricsters PPA to get packages like libminiupnpc-dev, ...
  sudo add-apt-repository -y ppa:glennric/dolphin-emu

  sudo apt-get update

  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev binutils-dev \
			  debhelper cmake libao-dev libasound2-dev libavcodec-dev libavformat-dev \
			  libbluetooth-dev libglew-dev libgtk2.0-dev liblzo2-dev libopenal-dev libpolarssl-dev \
			  libpulse-dev libreadline6-dev libsdl1.2-dev libsfml-dev libsoil-dev libsoundtouch-dev \
			  libswscale-dev libminiupnpc-dev libwxbase3.0-dev libwxgtk3.0-dev libxext-dev \
			  libxrandr-dev lsb-release pkg-config portaudio19-dev wx3.0-headers zlib1g-dev \
			  libjack-dev libjack0 libportaudio-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-dolphin-emu-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/dolphin-emu"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/dolphin-emu

#create build directory
mkdir -p ~/packaging/dolphin-emu

#change to build directory
cd ~/packaging/dolphin-emu

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/dolphin-emu/dolphin-emu.dsc dolphin-emu-$PRE:$BASE.$PL.dsc
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" "dolphin-emu-$PRE:$BASE.$PL.dsc"

echo "original tarball"
wget https://launchpad.net/~hunter-kaller/+archive/ubuntu/ppa/+files/dolphin-emu_4.0git-0ubuntu1~filthypants1.tar.gz
tar xfz dolphin-emu_4.0git-0ubuntu1~filthypants1.tar.gz
rm dolphin-emu_4.0git-0ubuntu1~filthypants1.tar.gz

SRC_FOLDER=dolphin-emu-$BASE.$PL

mv dolphin $SRC_FOLDER

file $SRC_FOLDER

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi

#change to source folder
cd $SRC_FOLDER

#echo "patching .."
patch Source/Core/DolphinWX/X11Utils.cpp < ~/RetroRig/supplemental/dolphin-emu/X11Utils.cpp.patch
patch Source/Core/DolphinWX/FrameTools.cpp < ~/RetroRig/supplemental/dolphin-emu/FrameTools.cpp.patch

echo "changelog"
cp ~/RetroRig/supplemental/dolphin-emu/changelog debian/
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" debian/changelog

echo "control"
cp ~/RetroRig/supplemental/dolphin-emu/control debian/

if [[ -n "$1" ]]; then
  arg0=$1
else
  # set up default
  arg0=source
fi

case "$arg0" in
  compile)
    echo ""
    echo "##########################################"
    echo "Building binary package now"
    echo "##########################################"
    echo ""

    #build binary package
    debuild -us -uc

    if [ $? -eq 0 ]; then  
        echo ""
        echo "##########################################"
        echo "Building finished"
        echo "##########################################"
        echo ""
        ls -lah ~/packaging/dolphin-emu
         exit 0
    else  
        echo "debuild failed to generate the binary package, aborting"
        exit 1
    fi 
    ;;
  source)
    #get secret key
    gpgkey=`gpg --list-secret-keys|grep "sec   "|cut -f 2 -d '/'|cut -f 1 -d ' '`

    if [[ -n "$gpgkey" ]]; then

      echo ""
      echo "##########################################"
      echo "Building source package"
      echo "##########################################"
      echo ""
      echo ""
      echo ""
      echo "****** please copy your gpg passphrase into the clipboard ******"
      echo ""
      sleep 10

      debuild -S -sa -k$gpgkey

      if [ $? -eq 0 ]; then
        echo ""
        echo ""
        ls -lah ~/packaging/dolphin-emu
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/dolphin-emu/dolphin-emu_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/dolphin-emu/dolphin-emu_*.$PL""_source.changes; break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done

        exit 0
      else
        echo "debuild failed to generate the source package, aborting"
        exit 1
      fi
    else
      echo "secret key not found, aborting"
      exit 1
    fi
    ;;
esac






