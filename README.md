RetroRig Project for Ubuntu 14.04 LTS
===================================================
Version 0.6.4

RetroRig is shell script to setup a Linux x86_64 system  with several emulators, and XBMC as graphical 
front end.The inspiration for doing this lies almost completely with the RetroPie Project. I wanted to provide
something similar, but with XBMC, x86_64, and my favorite interface, "Rom Collection Browser."
This project is intended to be run on Ubuntu (currently 14.04 LTS) with an wireless Xbox 360 Controller. 
At some point in the future, I want to try and branch this to other distributions if possible, as well
as accomodate other controllers. Please see the release-roadmap file for ideas and future plans. 

I invite you to challenge the configs and scripts to help improve my ultimate goal to provide
an easy way to get up and running with RetroGaming on x86_64 Linux systems. Pull requests or
Issues are very much welcome! 

Thank you for your patience.

## Please Note!

RetroRig is meant to be a standalone setup for XBMC on Ubuntu
It is mainly targeted at folks wishing to repurpose an old PC. 

Warning! It will overwrite:

-Emulator configs for supported emulators:

	-ZSNES
	-Nestopia
	-Gens/GS
	-MAME
	-Stella
	-Mupen64Plus
	-PCSX
	-PCSX2
	-Dolphin
-Also configs related to:

	-qjoypad
	-Blacklisting xpad
	-Autostarted application entries (XBMC, qjoypad)
	-Some folder structures under ~/Games
	-xboxdrv init scripts and configurations

## Why XBMC and Ubuntu?

I mainly made the decision to use Ubuntu+XBMC for a few reasons. First of all is XBMC itself, which can
extend far beyond retro gaming, adding many benefits if you decided to utilize XBMC further down the 
line, ensuring your computer / partition is not sitting there unused for other tasks. Another reason
was ROM Collection Browser, which in my opinion, is truly amazing at organizing your ROMs. The artwork
scrappers, importers, sorting, filtering, launch options, and more make it truly fantastic.

So then, why Ubuntu? Well, 14.04 LTS recently debuted when I decided to start this, which as many know,
provides years of updates. Additionally, Ubuntu itself is rich with PPAs, software repositories, and
forum documentation. Yes, I could have used many other distributions, but Ubuntu has a wide scope,
and is a hot target for many folks. Arch Linux, or Debian Testing were other considerations. Of course, 
there are many pro's and con's to using Ubuntu, all of which are understandable. You can't appease 
everyone!

## Controller Setup:

I Tried to reflect the original controller as much as possible for some such as the NES and SNES. The
save/load/exit button assignments are constant for all emulators except pcsx and pcsx2 (working on it!):

Please see controller-cfg-list.txt for the complete set!
	

## ROMs

On first startup Rom Collection Browser will ask for games to import. Several emulators are supported
and built in for easy importing.ROMs for emualtors are NOT provided for legal reasons. Due to legal 
gray areas with BIOS files, they will not be provided for emulators that require them (e.g. pcsx, pcsx2).
Please do not request these items be added.

Currently importing ROMs into XBMC is a keyboard-less affair for the following emulators:

	-ZSNES
	-Nestopia
	-Gens/GS
	-MAME
	-Stella
	-Mupen64Plus
	-PCSX
	-PCSX2
	-Dolphin

All ROMs should be placed in the respective folder under "/home/$USER/Games/ROMs". In due time, I will
add more and more emulators. But until then, you can manually add them. In a later release, I plan on 
building in a text-based file browser to locate and import games. For now, you must copy them in the
folders under ~/Games. In the near future, I will load SSH and Samba for file transfers as optional
install items.

## Installation

Pre-requisites:

You will need the following two pacakges:

	-dialog
	-git

RetroRig will try to install them for you, but if you experience any issues starting the script,
enusre they exist with 'which dialog' or 'which git" to ensure they report back.

To clone this repo via the CLI:

`git clone https://github.com/ProfessorKaos64/RetroRig` 

Simply run `./config.setup.sh` after cloning.  You can also choose to just copy configuration files
from each folder if you wish to just steal some notes on how to setup the emulators. Please 
reference the issues area on Github for current issues, or the release-roadmap for upcoming 
items.

You can also download a zip file or by other means on the github page. This will install dialog and
git as prequisites before running RetroRig.

## Updating

The config-setup.sh script also currently contains mechanisms to upgrade Ubuntu, update the 
emulator binaries, and also a way to pull the latest files from github.

## Please Note

This project is not yet complete. 

Project notes and guide will be hosted at www.libregeek.org

# EOF #
