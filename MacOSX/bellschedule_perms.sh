# Resetting perms for /Users/Shared/BellSchedule

chown -R root:everyone /Users/Shared/BellSchedule
chmod -R a-rwx /Users/Shared/BellSchedule
chmod -R u+rwX /Users/Shared/BellSchedule
chmod -R g+rwX /Users/Shared/BellSchedule
chmod -R o+rX /Users/Shared/BellSchedule
rm -f /Users/Shared/BellSchedule/bellschedule_settings.conf
