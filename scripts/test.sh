#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
printf "\n\n\n\tTEST SCRIPT: Let's see if we're good ...\t🤔\n\n\n\n🗿\n\t🗿\n\t\t🗿\n\t\t\t🗿\n\t\t\t\t🗿\n\t\t\t\t\t🗿\n\t\t\t\t\t\t🗿\n\t\t\t\t\t\t\t🗿\n\t\t\t\t\t\t\t\t🗿\n\n\n\n"
SECONDS=0
if ./scripts/docker.sh "$@"
then
    RESULTS="\n\n\n\tTEST SCRIPT: All Good!\t🍕"
else
    RESULTS="\n\n\n\tTEST SCRIPT: Not Good!\t😱😬😅😓😭🤷"
fi

if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    printf "$RESULTS\n\n\tCompleted in $hours hour(s), $minutes minute(s) and $seconds second(s).\n\n\n\n"
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    printf "$RESULTS\n\n\tCompleted in $minutes minute(s) and $seconds second(s).\n\n\n\n"
else
    printf "$RESULTS\n\n\tCompleted in $SECONDS second(s).\n\n\n\n"
fi

