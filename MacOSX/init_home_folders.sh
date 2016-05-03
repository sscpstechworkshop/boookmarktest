# This script will query an AD OU and create user folders based on the return

OU="OU=Student,OU=Users,OU=Test,OU=SSCPS,DC=ad,DC=sscps,DC=org"
folders=( Documents Downloads Movies Music Desktop Public )
local_storage_path="/Storage"
local_server="TEST-MAC-FS"

# Populate users array with objects in specified OU, using test/test123 AD account
users=(`ldapsearch -H ldap://ad.sscps.org -x -D "test@ad.sscps.org" -w test123 -b $OU -s sub "(objectClass=user)" sAMAccountName | awk '/^sAMAccountName: /{print $NF}'`)

for u in ${users[@]}
do
   home_dir=(`ldapsearch -H ldap://ad.sscps.org -x -D "test@ad.sscps.org" -w test123 -b $OU -s sub "(samaccountname=$u)" homeDirectory | awk '/^homeDirectory: /{print $NF}'`)
# Create different variables for server, share and user root folder

   user_root_folder=${home_dir##*\\}      # "jmcsheffrey"
   share_tmp=${home_dir%\\*}              # "\\TEST-MAC_FS\StudentUserFiles"
   share=${share_tmp##*\\}                # "StudentUserFiles"
   server_tmp=${share_tmp%\\*}            # "\\TEST-MAC-FS"
   server=${server_tmp#\\\\*}             # "TEST-MAC-FS"
   new_home_dir=$local_storage_path/$share/$user_root_folder  # "/Storage/StudentUserFiles/jmcsheffrey"

# Check that server variable is equal to local_server variable
# If they don't match do nothing and continue to next user   
   if [ "$local_server" != "$server" ]; then
      echo "Server mismatch for user: " $u
      continue;
   fi
   mkdir -p $new_home_dir
   chown $u $new_home_dir 
   chmod u+rwX $new_home_dir
      for f in ${folders[@]}
      do
         mkdir -p $new_home_dir/${folders[@]}
         chown $u $new_home_dir/${folders[@]}
         chmod u+rwX $new_home_dir/${folders[@]}
      done
done

