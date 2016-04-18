# based on install LXQT from 16.03 download
# update whole system
sudo pacman -Syyuu
# install packages as needed
sudo pacman -S base-devel binutils git
sudo pacman -S libreoffice
sudo pacman -S wine
sudo pacman -S gimp inkscape audacity blender
sudo pacman -S filezilla firefox
sudo pacman -S xscreensaver menda-themes menda-themes-dark qtcurve-qt4 qtcurve-qt5 xcursor-menda menda-circle-icon-theme faenza-icon-theme openbox-themes xcursor-menda
sudo pacman -S kate konsole dolphin
# setup Google Chrome
sudo pacman -R chromium
yaourt -S google-chrome
sudo pacman -S kdebase-kdialog ttf-liberation
# setup Atom text/development editor
yaourt -S atom-editor
#adjust sudoers
