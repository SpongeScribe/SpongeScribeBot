#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
#docker run -it $(docker build ../ -q --target dev) "$@"
docker run -v $PWD/data/in:/usr/local/app/data/in -v $PWD/data/out:/usr/local/app/data/out -it $(docker build . -q --target dev) "$@"
