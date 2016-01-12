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
declare -a exceptions=(sscpslocal student teacher Shared)

# use find to single out folders older than 14 days
# and populate them to array folders
folders=(`find /Users -maxdepth 1 -mindepth 1 -type d -ctime +14`)

# loop through array and delete folders not in exceptions array
# until 10GB disk space is free, then exit

while ($f in folders); do
   # check free space, if over target exit
   if [ freeDiskSpace > targetFreeDiskSpace ]; then
      break
   fi
   # check if folder is in exception array, skip if true
   if [[ " ${exceptions[@]}" =~ " $f " ]]; then
      continue
   else
      rm -rf $f
      freeDiskSpace=df -k | grep -E '^/dev/disk1' | awk '{print $4}'
done

