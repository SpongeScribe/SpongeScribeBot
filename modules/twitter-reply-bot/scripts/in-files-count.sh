#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
FOLDER="in"
FOLDER_SPACE_ADJUST=""

if  [ "$1" == "--nonewline" ] ; then
    NONEWLINE="$1"
	shift
fi
if  [ "$1" == "--oneline" ] || [ "$1" == "--one-line" ] || [ "$1" == "-1" ] ; then
    ONELINE="$1"
	shift
fi
if  [ "$1" == "--nonewline" ] ; then
    NONEWLINE="$1"
	shift
fi
if  [ ! -z "$1" ] ; then
    FOLDER="$1"
fi
if  [ ! -z "$2" ] ; then
    FOLDER_SPACE_ADJUST="$2"
fi
./scripts/files-count.sh $ONELINE $NONEWLINE $FOLDER $FOLDER_SPACE_ADJUST
