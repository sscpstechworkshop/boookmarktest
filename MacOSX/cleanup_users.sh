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

# remove exceptions from folders array
for e in ${exceptions[@]}
do
   echo "Removing from folders array because it is an exception: "$e

   # TODO FIX THE FOLLOWING LINE
   folders=(${folders[@]/$e})
done

# Troubleshooting loop
for i in ${folders[@]}
do
   echo "In folders array after exceptions loop: " $i
done

# loop through folders array and delete until
# target disk space is free, then exit
#for f in "${folders[@]}"
#do
#    echo "Deleting user folder:  "$f
#    rm -rf /Users/$f
#    freeDiskSpace=(`df -k | grep -E '^/' | awk '{print $4}'`)
#    echo "After deleting "$f" there is "$freeDiskSpace" space left"
#    # check free space, if over target exit
#    if [ $freeDiskSpace -gt $targetFreeDiskSpace ]; then
#       echo "Exiting script because free space is fine after deleting "$f
#       exit 0
#    fi
#done

