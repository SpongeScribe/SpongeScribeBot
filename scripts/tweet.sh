#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
WORKDIR=/usr/local/app
docker run -it -v $PWD/.env:$WORKDIR/.env $(docker build . -q --target twitter) "$@"
