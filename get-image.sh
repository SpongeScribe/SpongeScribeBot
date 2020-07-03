#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

docker cp $(docker run -v $PWD/in:/usr/local/app/in -d $(docker build app -q) entrypoint.sh $*; sleep 5):/usr/local/app/out/. ./out/
