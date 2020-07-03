#!/bin/bash
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

set -ex

if [[ -n $1 ]]; then
	SLEEP_SECONDS="$1"
else
	SLEEP_SECONDS=30
fi

export SLEEP_SECONDS=$SLEEP_SECONDS
echo "SLEEP_SECONDS=$SLEEP_SECONDS" | tee --append .env
echo "Sleep for: $SLEEP_SECONDS"

if command -v npm &> /dev/null
then
	echo "npm found, using 'npm run sleep' action."
	npm run sleep
else
    echo "npm not found, using 'sleep' command"
    sleep $SLEEP_SECONDS
fi
