# do updates without "looking" & cleanup afterwards
# quick link to master copy = https://goo.gl/SViJLz
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
echo ===============================
echo   Cleaning up packages
echo ===============================
apt-get -y autoremove
apt-get clean
