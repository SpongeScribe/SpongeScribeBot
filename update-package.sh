#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
echo "Update started."
if [[ -f "./app/package.json" ]]; then
    if [[ -n "$1" ]]; then
        echo "Commands present: $*"
        # The 79 NPM commands plus some flags, as of date: 2020-07-03, npm ./app/version: 6.14.5
        if [ "$1" == "update" ] || [ "$1" == "install" ] || [ "$1" == "uninstall" ] || [ "$1" == "-v" ] || [ "$1" == "-h" ] || [ "$1" == "--version" ] || [ "$1" == "" ] || [ "$1" == "access" ] || [ "$1" == "adduser" ] || [ "$1" == "audit" ] || [ "$1" == "bin" ] || [ "$1" == "bugs" ] || [ "$1" == "c" ] || [ "$1" == "cache" ] || [ "$1" == "ci" ] || [ "$1" == "cit" ] || [ "$1" == "clean-install" ] || [ "$1" == "clean-install-test" ] || [ "$1" == "completion" ] || [ "$1" == "config" ] || [ "$1" == "create" ] || [ "$1" == "ddp" ] || [ "$1" == "dedupe" ] || [ "$1" == "deprecate" ] || [ "$1" == "dist-tag" ] || [ "$1" == "docs" ] || [ "$1" == "doctor" ] || [ "$1" == "edit" ] || [ "$1" == "explore" ] || [ "$1" == "fund" ] || [ "$1" == "get" ] || [ "$1" == "help" ] || [ "$1" == "help-search" ] || [ "$1" == "hook" ] || [ "$1" == "i" ] || [ "$1" == "init" ] || [ "$1" == "install-ci-test" ] || [ "$1" == "install-test" ] || [ "$1" == "it" ] || [ "$1" == "link" ] || [ "$1" == "list" ] || [ "$1" == "ln" ] || [ "$1" == "login" ] || [ "$1" == "logout" ] || [ "$1" == "ls" ] || [ "$1" == "org" ] || [ "$1" == "outdated" ] || [ "$1" == "owner" ] || [ "$1" == "pack" ] || [ "$1" == "ping" ] || [ "$1" == "prefix" ] || [ "$1" == "profile" ] || [ "$1" == "prune" ] || [ "$1" == "publish" ] || [ "$1" == "rb" ] || [ "$1" == "rebuild" ] || [ "$1" == "repo" ] || [ "$1" == "restart" ] || [ "$1" == "root" ] || [ "$1" == "run" ] || [ "$1" == "run-script" ] || [ "$1" == "s" ] || [ "$1" == "se" ] || [ "$1" == "search" ] || [ "$1" == "set" ] || [ "$1" == "shrinkwrap" ] || [ "$1" == "star" ] || [ "$1" == "stars" ] || [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "t" ] || [ "$1" == "team" ] || [ "$1" == "test" ] || [ "$1" == "token" ] || [ "$1" == "tst" ] || [ "$1" == "un" ] || [ "$1" == "unpublish" ] || [ "$1" == "unstar" ] || [ "$1" == "up" ] || [ "$1" == "v" ] || [ "$1" == "version" ] || [ "$1" == "view" ] || [ "$1" == "whoami" ]; then
            COMMANDS="$*"
        # Else assuming trying to install something.
        else
            echo "Script did not recognize '$1' as npm command."
            echo "Assuming list of ./app/packages, attempting 'npm install'"
            COMMANDS="install $*"
        fi
    else
        echo "No commands present. Running 'npm update'..."
        COMMANDS="update"
    fi


    echo "Updating ./app/package.json..."
    if [[ -f "./app/package.json.temp" ]]; then
        echo "Previous './app/package.json.temp' found. Deleting..."
        rm ./app/package.json.temp
    fi

    echo "Build Image, Run Image."
    docker build app --target install
    DOCKER_CONTAINER_ID=$(docker run -d $(docker build app -q --target install) "$COMMANDS");

    timeout 20 docker logs --details --follow --timestamps $DOCKER_CONTAINER_ID

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
