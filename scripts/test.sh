#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
printf "\n\n\nTEST SCRIPT:\tLet's see if we're good ... 🤔\n\n\t🗿\n\n\n"
SECONDS=0
if ./scripts/docker.sh "$@"
then
	printf "\n\n\n\nTEST SCRIPT:\tAll Good!\t🍕\n\n\n\n"
else
	printf "\n\n\n\nTEST SCRIPT:\tNot Good!\t😱😬😅😓😭🤷\n\n\n\n"
fi

if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
else
    echo "Completed in $SECONDS seconds"
fi

