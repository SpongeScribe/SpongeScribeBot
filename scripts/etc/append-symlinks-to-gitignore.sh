#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
./scripts/etc/create-data-dirs-and-symlinks.sh
DATE=$(date -Ins)
LOCAL_USER=$(whoami)
$NPM_USER=$(npm whoami 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
		NPM_USER=$(yarn whoami 2>&1) && exit_status=$? || exit_status=$?
		if [ "$exit_status" -ne 0 ] ; then
		    	NPM_USER=""
		fi
fi
echo "NPM_USER=$NPM_USER"
printf "\n# SYMLINK-GITIGNORE-AUTOMATION-START - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
find . -type l | sed 's|^./||' | xargs -I {} -n1 /bin/echo "/{}" >> .gitignore
printf "\n# SYMLINK-GITIGNORE-AUTOMATION-END   - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
