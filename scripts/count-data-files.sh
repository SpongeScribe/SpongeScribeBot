#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
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
