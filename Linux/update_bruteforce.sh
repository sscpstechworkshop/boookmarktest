# do updates without "looking" & cleanup afterwards
# quick link to master copy = http://goo.gl/V8GjhV
apt-get update
# doing both because Kernels not done in former, and system utils not done in later
apt-get -y upgrade
aptitude -y --full-resolver safe-upgrade
apt-get -y autoremove
apt-get clean
