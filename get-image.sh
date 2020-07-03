# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#!/bin/bash

set -ex

docker cp $(docker run -d $(docker build . -q) entrypoint.sh $1; sleep 1):/usr/local/app/out.png ./out.png
