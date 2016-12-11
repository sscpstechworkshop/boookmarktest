# shortened URL for download:  TBD
#
# This assumes you've used https://ubuntu-mate.org/raspberry-pi/
#
# do all updates
apt-get update
rpi-update
#
apt-get -y install mc
apt-get -y install w3m w3m-img
apt-get -y install git git-doc
#
# install preferred apps
apt-get -y install ubuntu-restricted-extras
apt-get -y install chromium-browser filezilla
apt-get -y install vlc gimp marble inkscape audacity blender
#
# download regular update script
mkdir -p /home/System/scripts/
cd /home/System/scripts/
wget https://raw.githubusercontent.com/SSCPS/TechTools/master/Linux/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
# cleanup after everything is done
apt-get -y autoremove
apt-get clean
