# SCRIPT NOT COMPLETED
# This script will delete all local user home folders in /Users
# except sscpslocal, student, teacher, Shared
# and any AD users in SG_Policy_MacWriteLocal group
# until 10GB space is free

# how much space is free?
freeDiskSpace=(`df -k | grep -E '^/' | awk '{print $4}'`)
echo "Initial free disk space is " $freeDiskSpace

# How much space do we want free (in kilobytes)?
targetFreeDiskSpace=15000000

# exit immediately if free space is okay
if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
   echo "Free space is fine, exiting script..."
   exit 0
fi

# Populate the folders array with all folders in /Users
# sorted by oldest first
folders=(`ls -rt /Users`)

# troubleshooting contents of folders array
for f in ${folders[@]}
do
   echo "In folders array: " $f
done

# create exceptions array
exceptions=( sscpslocal student teacher Shared )
for f in ${folders[@]}
do
   groups=$(id -Gn $f)
   if [[ $groups =~ "SG_Policy_MacWriteLocal" ]]; then
      echo "Adding "$f" to exception list because they are in local Mac group..."
      exceptions+=($f)
   fi
done

