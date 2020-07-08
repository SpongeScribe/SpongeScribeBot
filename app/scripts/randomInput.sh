#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
if [ -z $TEXT]; then
	TEXT="Hello!\nPotato."
fi

FILENAME=./data/in/input.random.`uuidgen`.json
echo "{
    \"items\": [
        { \"USER\" : \"TEST\", \"TEXT\" : \"$TEXT\" }" > $FILENAME;
for run in {1..10}; do
	USER=`uuidgen`
	for run in {1..100}; do
		echo "        , { \"USER\" : \"$USER\", \"TEXT\" : \"$(uuidgen)\" }" >> $FILENAME;
	done
done
echo "    ]" >> $FILENAME
echo "}" >> $FILENAME
