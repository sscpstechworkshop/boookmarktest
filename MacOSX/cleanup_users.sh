# SCRIPT NOT COMPLETED 
# This script will delete all local user home folders in /Users
# except sscpslocal, student, teacher, Shared
# and any AD users in SG_Policy_MacWriteLocal group
# until 10GB space is free

# how much space is free?
freeDiskSpace=(`df -k | grep -E '^/dev/disk1' | awk '{print $4}'`)

# How much space do we want free (in kilobytes)?
targetFreeDiskSpace=10000000

# exit immediately if free space is okay
if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
   exit
fi

# Populate the folders array with all folders in /Users 
# sorted by oldest first
folders=(`ls -rt`)

# create exceptions array
exceptions=(sscpslocal student teacher Shared)
for f in "${folders[@]}";
do
   groups=$(id -Gn $f)
   if [[ $groups =~ "SG_Policy_MacWriteLocal" ]]; then
   	exceptions+=($f)
   fi
done

# remove exceptions from folders array
for e in "${exceptions[@]}";
do
   folders=(${folders[@]/$e})
done

# loop through folders array and delete until
# target disk space is free, then exit
while [ $f in folders ] 
do
      rm -rf /Users/$f
      freeDiskSpace=(`df -k | grep -E '^/dev/disk1' | awk '{print $4}'`)
   # check free space, if over target exit
   if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
      exit
   fi
done

