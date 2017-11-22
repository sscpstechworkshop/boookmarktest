# do updates without "looking" & cleanup afterwards
# quick link to master copy = https://goo.gl/SViJLz
# long link to master copy = https://raw.githubusercontent.com/SSCPS/TechTools/master/Linux/update_bruteforce.sh
echo ===============================
echo   Retreiving updated packages
echo ===============================
apt-get update
# doing both because Kernels not done in former, and system utils not done in later
echo ===============================
echo   Installing updated packages
echo ===============================
apt-get -y upgrade
echo ===============================
echo   Forcing held-back packages
echo ===============================
aptitude -y --full-resolver safe-upgrade
#
# uncomment each item below as needed
#
#echo ===============================
#echo   Renew LetsEncrypt SSL Certs
#echo ===============================
#sudo letsencrypt renew
#
#echo As sscpslocal, please run: "bash <(curl -s -S -L https://git.io/install-gam)"
#echo Do not setup new project!
#
echo ===============================
echo   Cleaning up packages
echo ===============================
apt-get -y autoremove
apt-get clean
