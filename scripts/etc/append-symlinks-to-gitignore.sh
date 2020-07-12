#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
set -x
./scripts/etc/create-data-dirs-and-symlinks.sh
DATE=$(date -Ins)
LOCAL_USER=$(whoami)
echo "LOCAL_USER=$LOCAL_USER"
$NPM_USER=$(npm whoami 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
		NPM_USER=$(yarn npm whoami 2>&1) && exit_status=$? || exit_status=$?
		if [ "$exit_status" -ne 0 ] ; then
		    	NPM_USER=""
		fi
fi
echo "NPM_USER=$NPM_USER"
printf "\n# SYMLINK-GITIGNORE-AUTOMATION-START - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
find . -type l | sed 's|^./||' | xargs -I {} -n1 /bin/echo "/{}" >> .gitignore
printf "# SYMLINK-GITIGNORE-AUTOMATION-END   - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
