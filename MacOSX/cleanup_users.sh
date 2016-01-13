# SCRIPT NOT COMPLETED 
# This script will delete all local user home folders in /Users
# except sscpslocal, student, teacher, Shared
# that are 14 days or older or until 10GB space is free

# how much space is free?
freeDiskSpace=df -k | grep -E '^/dev/disk1' | awk '{print $4}'

# How much space do we want free (in kilobytes)?
targetFreeDiskSpace=10000000

# we want to exit immediately if space is fine
if [ freeDiskSpace > targetFreeDiskSpace ]; then
   exit

# Populate the folders array with all folders in /Users 
# sorted by oldest first
folders=(`ls -rt`)

# modify folders array to exclude exceptions
# (including users in SG_Policy_MacWriteLocal AD group)
exceptions=(sscpslocal student teacher Shared)
for f in "${folders[@]}"
do
   groups=$(id -Gn $f)
      if [[ $groups =~ "SG_Policy_MacWriteLocal" ]]; then
	       exceptions+=($f)
done

# remove exceptions from folders array
TODO loop through exceptions array and remove all items from folders array
for e in "${exceptions[@]}"
do
   folders=(${folders[@]/$e})
done

# loop through folders array and delete items
# until 10GB disk space is free, then exit
while [ $f in folders ] 
do
      rm -rf /Users/$f
      freeDiskSpace=df -k | grep -E '^/dev/disk1' | awk '{print $4}'
   # check free space, if over target exit
   if ( freeDiskSpace > targetFreeDiskSpace )
   then
      exit
done

