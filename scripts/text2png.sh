#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
WORKDIR=/usr/local/app
touch .env
docker cp $(docker run -v $PWD/.env:$WORKDIR/.env -v $PWD/data:$WORKDIR/data -d $(docker build . -q) entrypoint.sh "$@"; sleep 5):$WORKDIR/data/out/. data/out/
