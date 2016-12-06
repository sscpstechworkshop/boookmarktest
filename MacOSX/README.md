mac-login-scripts
=================

Mac Login Scripts (helper scripts for using in school network)

There are currently 4 bash scripts and their associated PLIST file.  The script is run when a user logs in, with the exception of cleanup_users.sh, which runs on boot up.   All PLIST files should be located at /Library/LaunchAgents (user logs in) or /Library/LaunchDaemons (boot up).  

The scripts are:

  - home_folder_lock.sh      - to prevent user from writing to certain folders on local machine.  used only when
                               Mac's are configured with AD logins that create local home directory but have the
                               networked home folder added to the dock.  PLEASE READ FILE FOR MORE INFORMATION.
  - home_folder_lock.plist   - /Library/LaunchAgents
  - untangle_logon.sh        - this is an adaptation of the scripts supplied by untangle.com for windows active
                               directory authentication integration.  PLEASE READ FILE FOR MORE INFORMATION.
  - untangle_logon.plist     - /Library/LaunchAgents
  - reset_chrome.sh          - this script erases the local student/teacher Chrome support files to remove any user data
  - cleanup_users.sh         - cleans up older user folders in /Users when drive is less than 10GB free.   Matching 
                               plist file (cleanup_users.plist) goes in /Library/LaunchDaemons/
  - bellschedule.sh          - runs bells
  - bellschedule.plist       - /Library/LaunchAgents
  - bellschedule_perms.plist - /Library/LaunchDaemons
  - bellschedule_perms.sh    - sets up /Users/Shared/BellSchedule folder permissons
