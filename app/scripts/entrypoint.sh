#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
if  [ "$1" = "--override" ]; then
	OVERRIDE=0
	printf 'Override mode activated. Sending second argument as command. \n'
	shift
	COMMAND=$1
	shift
else
	COMMAND=start
fi
IMAGE_TEXT="$@"
export IMAGE_TEXT=$IMAGE_TEXT
echo "IMAGE_TEXT=$IMAGE_TEXT" | tee --append .env /etc/environment
if [ ! -z $IMAGE_TEXT ]; then
    FILENAME=./data/in/input.manual.`uuidgen`.json
    echo "{ \"items\": [ { \"username\" : \"@@MANUAL\", \"imageText\" : \"$IMAGE_TEXT\" } ] }" >> $FILENAME
    cat $FILENAME
fi

npm run-script $COMMAND
