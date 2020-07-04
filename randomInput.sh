#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
if [ -z $IMAGE_TEXT]; then
	IMAGE_TEXT="Hello!\nPotato."
fi

FILENAME=./appdata/in/input.random.`uuidgen`.json
echo "{
    \"items\": [
        { \"username\" : \"TEST\", \"imageText\" : \"$IMAGE_TEXT\" }" > $FILENAME;
for run in {1..10}; do
	USERNAME=`uuidgen`
	for run in {1..100}; do
		echo "        , { \"username\" : \"$USERNAME\", \"imageText\" : \"$(uuidgen)\" }" >> $FILENAME;
	done
done
echo "    ]" >> $FILENAME
echo "}" >> $FILENAME
