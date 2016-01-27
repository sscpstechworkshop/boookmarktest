# This script will delete all local user home folders in /Users
# except items in exceptions array
# and any AD users in SG_Policy_MacWriteLocal group until 10GB space is free
# place this file in /usr/sbin/ and chmod +x it

# how much space is free?
freeDiskSpace=(`df -k / | grep -E '^/' | awk '{print $4}'`)

# How much space do we want free (in kilobytes)?
targetFreeDiskSpace=10000000

# exit immediately if free space is okay
if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
   exit 0
fi

# Populate the folders array with all folders in /Users
# sorted by oldest first
folders=(`ls -rt /Users`)

# troubleshooting loop
# display contents of folders array
#for f in ${folders[@]}
#do
#   echo "In folders array: " $f
#done

# create exceptions array
exceptions=( sscpslocal student teacher Shared .localized)
for f in ${folders[@]}
do
   groups=$(id -Gn $f)
   if [[ $groups =~ "SG_Policy_MacWriteLocal" ]]; then
      exceptions+=($f)
   fi
done

# remove exceptions from folders array
for e in ${exceptions[@]}
do
   # TODO: our test user folders that end _student are getting "student" removed because of static exception
   # I can live with that for now, need to get this done because drives are filling up
   folders=(${folders[@]/$e})
done

# Troubleshooting loop
#for i in ${folders[@]}
#do
#   echo "In folders array after exceptions loop: " $i
#done

# loop through folders array and delete until
# target disk space is free, then exit
for f in ${folders[@]}
do
#    echo "Deleting user folder:  "$f
    rm -rf /Users/$f
    freeDiskSpace=(`df -k / | grep -E '^/' | awk '{print $4}'`)
    # check free space, if over target exit
    if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
       exit 0
    fi
done
