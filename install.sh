#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

if [ "$1" == "install" ] || [ "$1" == "-override" ]; then
  npm $*
else
  npm install $*
fi

npm run sleep
