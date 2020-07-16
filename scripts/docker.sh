#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
WORKDIR="/usr/local/app"
touch .env

echo "\$MANAGER=\"$MANAGER\""
echo "\$TARGET=\"$TARGET\""
echo "\$APP=\"$APP\""

echo "PARAMETERS=[[$@]]"
if [ -z "$MANAGER" ] ; then
    MANAGER="yarn"
fi
if  [ "$1" = "--yarn" ] ; then
    MANAGER="yarn"
    shift
elif  [ "$1" = "--npm" ] ; then
    MANAGER="npm"
    shift
fi

APP="$1"
shift

if [ -z "$1" ] ; then
	TARGET="default"
else
	TARGET="$1"
	shift
fi

echo "\$MANAGER=\"$MANAGER\""
echo "\$TARGET=\"$TARGET\""
echo "\$APP=\"$APP\""
echo "\$COMMAND=\"$@\""
docker run -v "$PWD/data/":"$WORKDIR/data/" -v "$PWD/.env":"$WORKDIR/.env" -it $(docker build -q . --build-arg WORKDIR="$WORKDIR" --build-arg MANAGER="$MANAGER" --target "$TARGET" --build-arg APP="$APP") "$@"
