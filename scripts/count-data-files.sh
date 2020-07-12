#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
if  [ "$1" == "--oneline" ] || [ "$1" == "--one-line" ] || [ "$1" == "-1" ] ; then
    NEWLINE=""
else
	NEWLINE="\n"
fi
printf "{ \"date\" : \"$(date -Ins)\" $NEWLINE, \"folders\" : [ $NEWLINE"
`pwd`/scripts/in-files-count.sh --nonewline $1
printf ", $NEWLINE"
`pwd`/scripts/out-files-count.sh --nonewline $1
printf "] } "
echo ""
