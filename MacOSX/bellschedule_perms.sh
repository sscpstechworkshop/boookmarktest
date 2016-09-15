# Resetting perms for /Users/Shared/BellSchedule

chown -R root:everyone /Users/Shared/BellSchedule
chmod -R u+rwx /Users/Shared/BellSchedule
chmod -R g+rwx /Users/Shared/BellSchedule
chmod -R o+rx /Users/Shared/BellSchedule
rm -f /Users/Shared/BellSchedule/bellschedule_settings.conf
