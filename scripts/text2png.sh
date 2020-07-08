#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
WORKDIR=/usr/local/app
docker cp $(docker run -v $PWD/.env:$WORKDIR/.env -v $PWD/data:$WORKDIR/data -d $(docker build . -q) entrypoint.sh "$@"; sleep 5):$WORKDIR/data/out/. data/out/
