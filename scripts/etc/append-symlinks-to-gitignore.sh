#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
set -x
./scripts/etc/create-data-dirs-and-symlinks.sh
DATE=$(date -Ins)
LOCAL_USER=$(whoami)
NPM_USER=$(npm whoami 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
	NPM_USER=$(cut -d " " -f3 <<< $(yarn npm whoami) 2>&1 | head -n 1 2>&1) && exit_status=$? || exit_status=$?
	if [ "$exit_status" -ne 0 ] ; then
    	NPM_USER=""
	fi
fi
GIT_USER_NAME=$(git config user.name 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
    GIT_USER_NAME=""
fi
GIT_USER_EMAIL=$(git config user.email 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
    GIT_USER_EMAIL=""
fi
GIT_USER_KEY=$(git config user.signingkey 2>&1) && exit_status=$? || exit_status=$?
if [ "$exit_status" -ne 0 ] ; then
    GIT_USER_KEY=""
fi
printf "\n# SYMLINK-GITIGNORE-AUTOMATION-START - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" GIT_USER_NAME=\"$GIT_USER_NAME\" GIT_USER_EMAIL=\"$GIT_USER_EMAIL\" GIT_USER_KEY=\"$GIT_USER_KEY\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
find . -type l | sed 's|^./||' | xargs -I {} -n1 /bin/echo "/{}" >> .gitignore
printf   "# SYMLINK-GITIGNORE-AUTOMATION-ENDED - DATE=\"$DATE\" NPM_USER=\"$NPM_USER\" GIT_USER_NAME=\"$GIT_USER_NAME\" GIT_USER_EMAIL=\"$GIT_USER_EMAIL\" GIT_USER_KEY=\"$GIT_USER_KEY\" LOCAL_USER=\"$LOCAL_USER\" SCRIPT=\"./scripts/etc/append-symlinks-to-gitignore.sh\"\n" >> .gitignore;
