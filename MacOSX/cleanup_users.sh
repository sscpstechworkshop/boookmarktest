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

# create array of local users to keep
exceptions=(sscpslocal student teacher Shared)

# use find to single out folders older than 14 days
# and populate them to array folders

folders=(`find /Users -maxdepth 1 -mindepth 1 -type d -ctime +14 | cut -c 8-28`)
# Note: cut command here takes the 8th character to possible 28th
# (stripping out /Users/) since AD is limited to 20 characters for account names

# loop through array and delete folders not in exceptions array
# until 10GB disk space is free, then exit
while [ $f in folders ] 
do
   # check if folder is in exception array, skip if true
   if (( " ${exceptions[@]}" =~ " $f " ))
   then
      continue
   else
      rm -rf /Users/$f
      freeDiskSpace=df -k | grep -E '^/dev/disk1' | awk '{print $4}'
   # check free space, if over target exit
   if ( freeDiskSpace > targetFreeDiskSpace )
   then
      exit
done

