#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
docker run -v $PWD/appdata/in:/usr/local/app/data/in -v $PWD/appdata/out:/usr/local/app/data/out -it $(docker build app -q --target dev) $*
