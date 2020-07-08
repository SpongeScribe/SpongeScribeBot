#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
WORKDIR=/usr/local/app
touch .env
docker run -v $PWD/.env:$WORKDIR/.env -v $PWD/data/in:$WORKDIR/data/in -v $PWD/data/out:$WORKDIR/data/out -it $(docker build . -q --target dev) "$@"
