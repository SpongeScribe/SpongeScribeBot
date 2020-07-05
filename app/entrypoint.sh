#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
IMAGE_TEXT="$*"
export IMAGE_TEXT=$IMAGE_TEXT
echo "IMAGE_TEXT=$IMAGE_TEXT" | tee --append .env /etc/environment
if [ ! -z $IMAGE_TEXT ]; then
    FILENAME=./data/in/input.manual.`uuidgen`.json
    echo "{
        \"items\": [
            { \"username\" : \"@@MANUAL\", \"imageText\" : \"$IMAGE_TEXT\" }" > $FILENAME;
    echo "    ]" >> $FILENAME
    echo "}" >> $FILENAME
fi
cat $FILENAME

npm run start
