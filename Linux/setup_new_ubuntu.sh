#!/bin/bash
# shortened URL = https://goo.gl/8lmEYR
# work in progress, use at your own risk
# assumptions:
#   1.  assumes its being run as root
#   2.  only tested from ubuntu 16.04 install
#   3.
# if you are behind a webfilter and need weblogin, try w3m
#
# TODO
#  1.  test to see if kubuntu-desktop is installed, if not install it
#  2.  is there a way to see about changing network setup from server to workstation?
#
# in case needed
# sudo usermod -aG sudo <username>
# make some directories used in script
mkdir -p /root/setup
mkdir -p /home/System/scripts
#
# update system first
apt-get update
apt-get -y install aptitude
apt-get -y upgrade
# force held-back packages
aptitude -y --full-resolver safe-upgrade
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# install some tools
#add-apt-repository -y ppa:webupd8team/java
apt-get update
#apt-get -y install oracle-java7-installer mc mutt usb-creator-kde
apt-get -y install mc mutt pv
apt-get -f -y install
# download script for "unattended" updating
cd /home/System/scripts/
# CHANGE:  be sure to update to correct repository
wget https://raw.githubusercontent.com/SSCPS/TechTools-Linux/master/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
#
# install DE in case needed to use Ubuntu Server CD for install
#apt-get -y install kubuntu-desktop
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# SSCPS Branding, install boot splash  theme
#need to be after desktop because that installs its own
apt-get -y install plymouth-theme-edubuntu
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
update-alternatives --set default.plymouth /lib/plymouth/themes/edubuntu-logo/edubuntu-logo.plymouth
update-grub
update-initramfs -u
#
# remove unneeded apps and add other needed apps.
#apt-get -y remove kpat ktorrent akregator kopete quassel
apt-get -y install ubuntu-restricted-extras wine filezilla
apt-get -y install ubuntu-wallpapers kde-wallpapers kde-wallpapers-default kdewallpapers xubuntu-wallpapers
apt-get -y install peace-wallpapers tropic-wallpapers lubuntu-artwork
apt-get -y install screensaver-default-images
apt-get -y install libreoffice-kde libreoffice-impress libreoffice-pdfimport
apt-get -y install libreoffice-templates openclipart-libreoffice openclipart2-libreoffice
apt-get -y install vlc gimp marble inkscape audacity blender
# development apps
apt-get -y install git git-doc build-essential eclipse kdevelop kdev-python
# extra media creation tools
apt-get -y install mediainfo-gui handbrake kdenlive kino kid3-qt digikam shotwell openshot ffmpeg kid3-qt lame
# yeah, flash is needed for firefox
apt-get -y remove flashplugin-installer
apt-get -y install flashplugin-installer
# clean up everything, drives are big, but images should be small.  :-)
apt-get -y autoremove
apt-get clean
#
# install Google Chrome
cd /root/setup
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb
apt-get -f -y install
#
# clean up everything
apt-get -y autoremove
apt-get clean
