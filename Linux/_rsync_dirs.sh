#!/bin/bash
#
# simple script to rsync local media directory to location, assumes source is master copy
#
# sample local directories
#vSourceDirectory="/home/someuser/MediaDir"
#vDestinationDirectory="/media/someuser/MediaDrive"
# sample local to remote, assumes ssh keys setup
#vSourceDirectory="/home/someuser/MediaDir"
#vDestinationDirectory="someuser@127.0.0.1:/home/someuser/MediaDirCopy"

rsync --verbose --recursive --update --copy-unsafe-links --times --whole-file --delete-during --force --human-readable --progress $vSourceDirectory $vDestinationDirectory
