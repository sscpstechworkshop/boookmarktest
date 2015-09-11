# do updates without "looking" & cleanup afterwards
# quick link to master copy = http://goo.gl/V8GjhV
apt-get update
aptitude -y --full-resolver safe-upgrade
# uncomment next two lines if system has Firefox installed
#apt-get -y remove flashplugin-installer
#apt-get -y install flashplugin-installer
apt-get -y autoremove
apt-get clean
