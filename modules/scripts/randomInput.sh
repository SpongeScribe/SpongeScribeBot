#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex

if [ -z "$USER" ]; then
	USER="TEST"
fi

if [ -z "$TEXT"]; then
	TEXT="Hello!\nPotato."
fi

FILENAME=./data/in/input.random.`uuidgen`.json

echo "{
    \"items\": [
        { \"user\" : \"$USER\", \"text\" : \"$TEXT\" }" > $FILENAME;

for run in {1..10}; do
	USER=`uuidgen`
	for run in {1..100}; do
		echo "        , { \"user\" : \"$USER\", \"text\" : \"$(uuidgen)\" }" >> $FILENAME;
	done
done

printf "    ]\n}\n" >> $FILENAME
