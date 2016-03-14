# keyring issue on installs from 12.15 download
sudo pacman-key --init 
sudo pacman-key --populate archlinux manjaro 
sudo dirmngr < /dev/null
sudo pacman-key --refresh-keys
# clean out bad downloads/updates/etc.
sudo pacman -Sc
# update whole system
sudo pmacman -Syyuu
# install packages as needed
sudo pacman -S kdeadmin-kuser wine
sudo pacman -S gimp inkscape audacity blender
sudo pacman -S filezilla
# these can't be run as root
yaourt -S google-chrome
yaourt -S atom-editor
#adjust sudoers
