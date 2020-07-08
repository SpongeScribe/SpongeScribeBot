#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
dir="*"
fileExtension1="png"
fileExtension2="json"
if [ -n "$1" ] ; then
	dir="$1"
	if [ -n "$2" ] ; then
		fileExtension1="$2"
		if [ -n "$3" ] ; then
			fileExtension2="$3"
		else
			fileExtension2=
		fi
	fi
fi

./in-files-count.sh
./out-files-count.sh

find data/$dir/*.* -name "*.$fileExtension1" -delete -o -name "*.$fileExtension2" -delete

./in-files-count.sh
./out-files-count.sh
