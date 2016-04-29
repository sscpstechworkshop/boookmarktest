# This script will query an AD OU and create user folders based on the return

OU="OU=Student,OU=Users,OU=Test,OU=SSCPS,DC=ad,DC=sscps,DC=org"
folders=( Documents Downloads Movies Music Desktop Public )

# Populate users array with objects in specified OU, using test/test123 AD account
users=(`ldapsearch -H ldap://ad.sscps.org -x -D "test@ad.sscps.org" -w test123 -b $OU -s sub "(objectClass=user)" sAMAccountName | awk '/^sAMAccountName: /{print $NF}'`)

for u in ${users[@]}
do
   home_dir=(`ldapsearch -H ldap://ad.sscps.org -x -D "test@ad.sscps.org" -w test123 -b $OU -s sub "(objectClass=user)" homeDirectory | awk '/^ homeDirectory: /{print $NF}'`)
   mkdir -p $home_dir
   chown $home_dir $u
      for f in ${folders[@]}
      do
         mkdir -p $home_dir/${folders[@]}
         chown $home_dir/${folders[@]} $u
      done
done
