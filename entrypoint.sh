#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex
IMAGE_TEXT=$1
export IMAGE_TEXT=$IMAGE_TEXT
echo "IMAGE_TEXT=$IMAGE_TEXT" | tee --append .env
npm run start
