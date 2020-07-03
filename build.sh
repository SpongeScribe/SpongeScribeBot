# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#!/bin/bash

rm -f ./version;
touch version;
printf "node=" >> version;
node -v >> version;
printf "npm=" >>version;
npm -v >> version;
printf "app=" >>version;
cat appversion >> version;
cat version; 

