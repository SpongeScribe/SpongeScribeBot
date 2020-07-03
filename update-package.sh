#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

rm -f package.json.temp
rm -f package-lock.json.temp

docker cp $(docker run -d $(docker build . -q --target install)):/usr/local/app/package.json ./package.json.temp

docker cp $(docker run -d $(docker build . -q --target install)):/usr/local/app/package-lock.json ./package-lock.json.temp

rm -f package.json
mv package.json.temp package.json

rm -f package-lock.json
mv package-lock.json.temp package-lock.json
