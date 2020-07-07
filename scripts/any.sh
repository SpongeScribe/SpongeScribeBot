#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
DOCKER_TARGET=$1
shift
docker run -it $(docker build -q . --target $DOCKER_TARGET) "$@"
