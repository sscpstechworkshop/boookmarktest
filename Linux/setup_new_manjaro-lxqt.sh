# based on install LXQT from 16.03 download
# update whole system
sudo pmacman -Syyuu
# install packages as needed
sudo pacman -R chromium
sudo pacman -S base-devel binutils git
sudo pacman -S wine
sudo pacman -S gimp inkscape audacity blender
sudo pacman -S filezilla firefox
sudo pacman -S xscreensaver menda-themes menda-themes-dark qtcurve-qt4 qtcurve-qt5 xcursor-menda menda-circle-icon-theme faenza-icon-theme openbox-themes xcursor-menda
sudo pacman -S kate konsole dolphin
sudo pacman -S libreoffice
# these can't be run as root
yaourt -S google-chrome
yaourt -S atom-editor
#adjust sudoers
