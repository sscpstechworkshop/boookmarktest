# NEED TO FIX:  shortened URL for download:  http://goo.gl/yvS79k
#
# do all updates
apt-get update
apt-get -y install aptitude
aptitude -y --full-resolver safe-upgrade
#
# install webmin
echo "" >> /etc/apt/sources.list
echo "# repositories added for webmin installation/update" >> /etc/apt/sources.list
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add /root/jcameron-key.asc
#
# install "standard" apps in regular repositories
apt-get update
apt-get -y install webmin
apt-get -y install mc
apt-get -y install w3m w3m-img
apt-get -y install mutt
apt-get -y install git git-doc
apt-get -y install openssh-server
#
# download regular update script
mkdir -p /home/System/scripts/
cd /home/System/scripts/
wget https://raw.githubusercontent.com/SSCPS/TechTools/master/Linux/update_bruteforce.sh
chmod a+x /home/System/scripts/update_bruteforce.sh
# cleanup after everything is done
apt-get -y autoremove
apt-get clean
