#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
if [[ -n $1 ]]; then
	SLEEP_SECONDS="$1"
else
	SLEEP_SECONDS=300
fi

export SLEEP_SECONDS=$SLEEP_SECONDS
echo "SLEEP_SECONDS=$SLEEP_SECONDS" | tee --append .env
echo "Sleep for: $SLEEP_SECONDS"

if command -v npm &> /dev/null
then
	echo "npm found, using 'npm run-script sleep' action."
	npm run-script sleep
else
    echo "npm not found, using 'sleep' command"
    sleep $SLEEP_SECONDS
fi
