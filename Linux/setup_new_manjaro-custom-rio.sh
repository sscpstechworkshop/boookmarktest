 keyring issue on installs from 12.15 download
sudo pacman-key --init 
sudo pacman-key --populate archlinux manjaro 
sudo dirmngr < /dev/null
sudo pacman-key --refresh-keys
# clean out bad downloads/updates/etc.
sudo pacman -Sc
# update whole system
sudo pmacman -Syyuu
# install packages as needed
sudo pacman -S base-devel binutils git
sudo pacman -S kdeadmin-kuser
sudo pacman -S wine
sudo pacman -S gimp inkscape audacity blender
sudo pacman -S filezilla
sudo pacman -S lxqt lxterminal oxygen-icons lxappearance obconf manjaro-settings-manager gvfs gvfs-afc leafpad qpdfview speedcrunch xscreensaver lxtask gvfs-mtp gvfs-gphoto2 octopi-repoeditor octopi-cachecleaner libdvdcss
# these can't be run as root
yaourt -S google-chrome
yaourt -S atom-editor
#adjust sudoers
