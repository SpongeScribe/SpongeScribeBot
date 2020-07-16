#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
echo "\$MANAGER=\"$MANAGER\""
echo "\$TARGET=\"$TARGET\""
echo "\$APP=\"$APP\""
echo "PARAMETERS=[[$@]]"
if [ -z "$WORKDIR" ] ; then
	WORKDIR="/usr/local/app"
fi
if  [ "$1" = "--no-cache" ] ; then
    DOCKER_NO_CACHE="$1"
    shift
fi
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
if [ -z "$1" ] ; then
	APP="node"
else
	APP="$1"
	shift
fi
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
if [ -z "$DOCKER_NO_CACHE" ] || [ "$APP" == "node" ]
then
	echo "Running './scripts/$MANAGER.sh' first as a sanity check..."
	"./scripts/$MANAGER.sh" "$APP"
fi
touch .env
if docker run -v "$PWD/data/":"$WORKDIR/data/" -v "$PWD/.env":"$WORKDIR/.env" -it $(docker build $DOCKER_NO_CACHE -q . --build-arg WORKDIR="$WORKDIR" --build-arg MANAGER="$MANAGER" --target "$TARGET" --build-arg APP="$APP") "$@"
then
	echo "exit 0"
	exit 0
else
	echo "exit 1"
	exit 1
fi
