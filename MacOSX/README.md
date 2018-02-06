Mac OS X Helper Scripts
=======================

System Scripts
--------------
There are currently 6 bash Mac Login Scripts (helper scripts for using in school network).  Each has an associated PLIST file. The ones with /Library/LaunchAgents are during login, and the /Library/LaunchDaemons are during bootup.  All .sh files should be located at /usr/local/bin/.

The scripts are:

  - home_folder_lock.sh      - to prevent user from writing to certain folders on local machine.  used only when
                               Mac's are configured with AD logins that create local home directory but have the
                               networked home folder added to the dock.  PLEASE READ FILE FOR MORE INFORMATION.
  - home_folder_lock.plist   - /Library/LaunchAgents
  - untangle_logon.sh        - this is an adaptation of the scripts supplied by untangle.com for windows active
                               directory authentication integration.  PLEASE READ FILE FOR MORE INFORMATION.
  - untangle_logon.plist     - /Library/LaunchAgents
  - bellschedule.sh          - runs bells
  - bellschedule.plist       - /Library/LaunchAgents
  - bellschedule_perms.sh    - sets up /Users/Shared/BellSchedule folder permissons
  - bellschedule_perms.plist - /Library/LaunchDaemons
  - reset_chrome.sh          - this script erases the local student/teacher Chrome support files to remove any user data
  - reset_chrome.plist       - /Library/LaunchDaemons
  - cleanup_users.sh         - cleans up older user folders in /Users when drive is less than 10GB free.   Matching 
                               plist file (cleanup_users.plist) goes in /Library/LaunchDaemons/
  - cleanup_users.plist      - /Library/LaunchDaemons


Misc Scripts
------------
  - ad_user_rsync.sh         - used before final issuance of laptop/desktop, to initially copy all user's files from server.
  - ad_user_move.sh          - used move files to new user profile.
  - cfg_wkn.sh               - TBD.
