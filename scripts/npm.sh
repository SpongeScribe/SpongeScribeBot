#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
echo "Update started."
if [[ -f "package.json" ]]; then
    echo "Updating package.json..."
    if [[ -f "package.json.temp" ]]; then
        echo "Previous 'package.json.temp' found. Deleting..."
        rm package.json.temp
    fi

    echo "Build Image, Run Image."
    docker build app --target install
    DOCKER_CONTAINER_ID=$(docker run -d $(docker build app -q --target install) "$@");

    { sed /sleep/q; kill $!; } < <(exec docker logs --details --follow --timestamps $DOCKER_CONTAINER_ID)

    echo "Copy File: container:'package.json' to local:'package.json.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/package.json package.json.temp


    echo "Updating package-lock.temp.json..."
    if [[ -f "package-lock.json.temp" ]]; then
        echo "Previous 'package-lock.json.temp' found. Deleting..."
        rm package-lock.json.temp
    fi

    echo "Copy File: container:'package-lock.json' to local:'package-lock.json.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/package-lock.json package-lock.json.temp


    echo "Updating version..."
    if [[ -f "VERSION.temp" ]]; then
        echo "Previous 'VERSION.temp' found. Deleting..."
        rm VERSION.temp
    fi

    echo "Run Image, Copy File: container:'VERSION' to local:'VERSION.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/VERSION VERSION.temp

    echo "Moving temp files to permanent locations..."

    echo "Moving 'package.json.temp' to 'package.json'..."

    if [[ -f "package.json.temp" ]]; then
        echo "Deleting 'package.json'..."
        rm package.json
        echo "Moving 'package.json.temp'..."
        cp package.json.temp package.json
        rm package.json.temp
    else
        echo "ERROR: 'package.json.temp' not found."
        exit 1
    fi

    echo "Moving 'package-lock.json.temp' to 'package-lock.json'..."

    if [[ -f "package-lock.json.temp" ]]; then
        echo "Deleting 'package-lock.json'..."
        rm -f package-lock.json
        echo "Moving 'package-lock.json.temp'..."
        cp package-lock.json.temp package-lock.json
        rm package-lock.json.temp
    else
        echo "ERROR: 'package-lock.json.temp' not found."
        exit 1
    fi

    echo "Moving temp files to permanent locations..."

    echo "Moving 'VERSION.temp' to 'VERSION.json'..."

    if [[ -f "VERSION.temp" ]]; then
        echo "Deleting 'VERSION'..."
        rm -f VERSION
        echo "Moving 'VERSION.temp'..."
        cp VERSION.temp VERSION
        rm VERSION.temp
    else
        echo "ERROR: 'VERSION.temp' not found."
        exit 1
    fi

else
    echo "ERROR: 'package.json' not found."
    exit 1
fi

echo "Update complete."
