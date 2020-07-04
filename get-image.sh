#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
docker cp $(docker run -v $PWD/appdata/in:/usr/local/app/data/in -v $PWD/appdata/out:/usr/local/app/data/out -d $(docker build app -q) entrypoint.sh $*; sleep 5):/usr/local/app/data/out/. ./data/out/
