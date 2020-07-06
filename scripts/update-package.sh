#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
echo "Update started."
if [[ -f "./app/package.json" ]]; then
    echo "Updating ./app/package.json..."
    if [[ -f "./app/package.json.temp" ]]; then
        echo "Previous './app/package.json.temp' found. Deleting..."
        rm ./app/package.json.temp
    fi

    echo "Build Image, Run Image."
    docker build app --target install
    DOCKER_CONTAINER_ID=$(docker run -d $(docker build app -q --target install) "$@");

    { sed /sleep/q; kill $!; } < <(exec docker logs --details --follow --timestamps $DOCKER_CONTAINER_ID)

    echo "Copy File: container:'./app/package.json' to local:'./app/package.json.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/package.json ./app/package.json.temp


    echo "Updating ./app/package-lock.temp.json..."
    if [[ -f "./app/package-lock.json.temp" ]]; then
        echo "Previous './app/package-lock.json.temp' found. Deleting..."
        rm ./app/package-lock.json.temp
    fi

    echo "Copy File: container:'./app/package-lock.json' to local:'./app/package-lock.json.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/package-lock.json ./app/package-lock.json.temp


    echo "Updating version..."
    if [[ -f "./app/version.temp" ]]; then
        echo "Previous './app/version.temp' found. Deleting..."
        rm ./app/version.temp
    fi

    echo "Run Image, Copy File: container:'./app/version' to local:'./app/version.temp'"
    docker cp $DOCKER_CONTAINER_ID:/usr/local/app/version ./app/version.temp

    echo "Moving temp files to permanent locations..."

    echo "Moving './app/package.json.temp' to './app/package.json'..."

    if [[ -f "./app/package.json.temp" ]]; then
        echo "Deleting './app/package.json'..."
        rm ./app/package.json
        echo "Moving './app/package.json.temp'..."
        cp ./app/package.json.temp ./app/package.json
        rm ./app/package.json.temp
    else
        echo "ERROR: './app/package.json.temp' not found."
        exit 1
    fi

    echo "Moving './app/package-lock.json.temp' to './app/package-lock.json'..."

    if [[ -f "./app/package-lock.json.temp" ]]; then
        echo "Deleting './app/package-lock.json'..."
        rm -f ./app/package-lock.json
        echo "Moving './app/package-lock.json.temp'..."
        cp ./app/package-lock.json.temp ./app/package-lock.json
        rm ./app/package-lock.json.temp
    else
        echo "ERROR: './app/package-lock.json.temp' not found."
        exit 1
    fi

    echo "Moving temp files to permanent locations..."

    echo "Moving './app/version.temp' to './app/version.json'..."

    if [[ -f "./app/version.temp" ]]; then
        echo "Deleting './app/version'..."
        rm -f ./app/version
        echo "Moving './app/version.temp'..."
        cp ./app/version.temp ./app/version
        rm ./app/version.temp
    else
        echo "ERROR: './app/version.temp' not found."
        exit 1
    fi

else
    echo "ERROR: './app/package.json' not found."
    exit 1
fi

echo "Update complete."
