#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
WORKDIR=/usr/local/app
touch .env
DOCKER_TARGET=$1
shift
docker run -v $PWD/data/in:$WORKDIR/data/in -v $PWD/data/out:$WORKDIR/data/out -v $PWD/.env:$WORKDIR/.env -it $(docker build -q . --target $DOCKER_TARGET) "$@"
