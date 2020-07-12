#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
DOCKER_CONTAINER_WORKDIR=/usr/local/app
##################
echo "Checking parameters ..."
echo "\$MANAGER=$MANAGER"
echo "PARAMETERS=[[$@]]"
if [ -z $MANAGER ] ; then
    MANAGER=yarn
fi
if  [ "$1" = "--yarn" ] ; then
    MANAGER=yarn
    shift
elif  [ "$1" = "--npm" ] ; then
    MANAGER=npm
    shift
fi
if  [ "$1" = "--final" ] ; then
    NO_RECURSE=TRUE
    shift
fi
##################
if [[ ! -e "./package.json" ]] ; then
    echo "ERROR: 'package.json' not found."
    if [[ -s "./package.json.temp" ]] ; then
        echo "Found: 'package.json.temp'"
        echo "Attempting to continue with 'package.json.temp'."
        echo "Copying 'package.json.temp' to 'package.json' ..."
        cp ./package.json.temp ./package.json
    else
        echo "ERROR: 'package.json.temp' not found."
        exit 1
    fi
fi
if [[ ! -e "./.yarnrc" ]] ; then
    echo "ERROR: '.yarnrc' not found."
    if [[ -s "./.yarnrc.temp" ]] ; then
        echo "Found: '.yarnrc.temp'"
        echo "Attempting to continue with '.yarnrc.temp'."
        echo "Copying '.yarnrc.temp' to '.yarnrc' ..."
        cp ./.yarnrc.temp ./.yarnrc
    fi
fi
if [[ ! -e "./.yarnrc.yml" ]] ; then
    echo "ERROR: '.yarnrc.yml' not found."
    if [[ -s "./.yarnrc.yml.temp" ]] ; then
        echo "Found: '.yarnrc.yml.temp'"
        echo "Attempting to continue with '.yarnrc.yml.temp'."
        echo "Moving '.yarnrc.yml.temp' to '.yarnrc.yml' ..."
        mv ./.yarnrc.yml.temp ./.yarnrc.yml
    fi
fi
if [[ ! -d "./.yarn/" ]] ; then
    echo "ERROR: '.yarn/' not found."

    if [[ -d "./.yarn.temp/" ]] ; then
        echo "Found: '.yarn.temp/'"
        echo "Attempting to continue with '.yarn.temp/'."
        echo "Moving '.yarn.temp/' to '.yarn/' ..."
        mv ./.yarn.temp/ ./.yarn/
    else
        echo "ERROR: '.yarn.temp/' not found."
        echo "Attempting to continue with clean run."

        echo "Creating empty '.yarn/' directory for Dockerfile ..."
        mkdir ./.yarn/

        if [[ -e "./.yarnrc" ]] ; then
            echo "Found: '.yarnrc'"
            echo "Moving '.yarnrc' to '.yarnrc.clean.temp' ..."
            if [[ -s "./.yarnrc.clean.temp" ]] ; then
                echo "ERROR: Previous '.yarnrc.clean.temp' found. Exiting ..."
                exit 1
            elif [[ -e "./.yarnrc.clean.temp" ]] ; then
                rm ./yarnrc.clean.temp
            fi
            mv ./.yarnrc ./.yarnrc.clean.temp
            echo "This file must be cleaned up manually: '.yarnrc.clean.temp'"
        fi

        if [[ -e "./.yarnrc.yml" ]] ; then
            echo "Found: '.yarnrc.yml'"
            echo "Moving '.yarnrc.yml' to '.yarnrc.yml.clean.temp' ..."
            if [[ -s "./.yarnrc.yml.clean.temp" ]] ; then
                echo "ERROR: Previous '.yarnrc.yml.clean.temp' found. Exiting ..."
                exit 1
            elif [[ -e "./.yarnrc.yml.clean.temp" ]] ; then
                rm ./yarnrc.yml.clean.temp
            fi
            mv ./.yarnrc.yml ./.yarnrc.yml.clean.temp
            echo "This file must be cleaned up manually: '.yarnrc.yml.clean.temp'"
        fi
    fi
fi
##################
echo "Build Install Image ..."
docker build --build-arg MANAGER="$MANAGER" . --target install
echo "Run Install Image, Kill Log Follow When Image Sleeps ..."
DOCKER_CONTAINER_ID=$(docker run -d $(docker build --build-arg MANAGER="$MANAGER" . -q --target install) "$@");
{ sed /sleep\ /q; kill $!; } < <(exec docker logs --details --follow --timestamps "$DOCKER_CONTAINER_ID")
##################
echo "Updating 'package.json' ..."
if [[ -e "./package.json.temp" ]] ; then
    echo "Previous 'package.json.temp' found. Deleting ..."
    rm ./package.json.temp
fi
echo "Docker Copy: FROM='container:./package.json' TO='local:./package.json.temp' ..."
docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/package.json" ./package.json.temp
echo "Moving 'package.json.temp' to 'package.json' ..."
if [[ -e "./package.json.temp" ]] ; then
    if [[ -e "./package.json" ]] ; then
        echo "Deleting 'package.json'..."
        rm ./package.json
    fi
    echo "Moving 'package.json.temp' ..."
    cp ./package.json.temp ./package.json
    rm ./package.json.temp
else
    echo "ERROR: 'package.json.temp' not found."
    exit 1
fi
##################
if [ "$MANAGER" = "yarn" ] ; then
    echo "Updating 'yarn.lock' ..."
    if [[ -e "./yarn.lock.temp" ]] ; then
        echo "Previous 'yarn.lock.temp' found. Deleting ..."
        rm -r ./yarn.lock.temp
    fi
    echo "Docker Copy: FROM='container:./yarn.lock' TO='local:./yarn.lock.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/yarn.lock" ./yarn.lock.temp
    echo "Moving 'yarn.lock.temp' to 'yarn.lock' ..."
    if [[ -e "./yarn.lock.temp" ]] ; then
        if [[ -e "./yarn.lock" ]] ; then
            echo "Deleting 'yarn.lock'..."
            rm ./yarn.lock
        fi
        echo "Moving 'yarn.lock.temp' ..."
        cp ./yarn.lock.temp ./yarn.lock
        rm -r ./yarn.lock.temp
    else
        echo "ERROR: 'yarn.lock.temp' not found."
        exit 1
    fi

    echo "Updating '.yarn/' ..."
    if [[ -e "./.yarn.temp/" ]] ; then
        echo "Previous '.yarn.temp/' found. Deleting ..."
        rm -r ./.yarn.temp/
    fi
    echo "Docker Copy: FROM='container:./.yarn' TO='local:./.yarn.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/.yarn/" ./.yarn.temp/
    echo "Moving '.yarn.temp/' to '.yarn/'..."
    if [[ -e "./.yarn.temp/" ]] ; then
        if [[ -d "./.yarn/" ]] ; then
            echo "Deleting '.yarn/'..."
            rm -r ./.yarn/
        fi
        echo "Moving '.yarn.temp/' ..."
        cp -r ./.yarn.temp/ ./.yarn/
        rm -r ./.yarn.temp/
    else
        echo "ERROR: '.yarn.temp/' not found."
        exit 1
    fi

    echo "Updating '.yarnrc' ..."
    if [[ -e "./.yarnrc.temp" ]] ; then
        echo "Previous '.yarnrc.temp' found. Deleting ..."
        rm ./.yarnrc.temp
    fi
    echo "Docker Copy: FROM='container:./.yarnrc' TO='local:./.yarnrc.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/.yarnrc" ./.yarnrc.temp
    echo "Moving '.yarnrc.temp' to '.yarnrc' ..."
    if [[ -e "./.yarnrc.temp" ]] ; then
        if [[ -e "./.yarnrc" ]] ; then
            echo "Deleting '.yarnrc' ..."
            rm ./.yarnrc
        fi
        echo "Moving '.yarnrc.temp' ..."
        cp ./.yarnrc.temp ./.yarnrc
        rm ./.yarnrc.temp
    else
        echo "ERROR: '.yarnrc.temp' not found."
        exit 1
    fi

    echo "Updating '.yarnrc.yml' ..."
    if [[ -e "./.yarnrc.yml.temp" ]] ; then
        echo "Previous '.yarnrc.yml.temp' found. Deleting ..."
        rm ./.yarnrc.yml.temp
    fi
    echo "Docker Copy: FROM='container:./.yarnrc.yml' TO='local:./.yarnrc.yml.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/.yarnrc.yml" ./.yarnrc.yml.temp
    echo "Moving '.yarnrc.yml.temp' to '.yarnrc.yml' ..."
    if [[ -e "./.yarnrc.yml.temp" ]] ; then
        if [[ -e "./.yarnrc.yml" ]] ; then
            echo "Deleting '.yarnrc.yml' ..."
            rm ./.yarnrc.yml
        fi
        echo "Moving '.yarnrc.yml.temp' ..."
        cp ./.yarnrc.yml.temp ./.yarnrc.yml
        rm ./.yarnrc.yml.temp
    else
        echo "ERROR: '.yarnrc.yml.temp' not found."
        exit 1
    fi
##################
elif [ "$MANAGER" = "npm" ] ; then
    echo "Updating 'package-lock.json' ..."
    if [[ -e "./package-lock.json.temp" ]] ; then
        echo "Previous 'package-lock.json.temp' found. Deleting ..."
        rm ./package-lock.json.temp
    fi
    echo "Docker Copy: FROM='container:./package-lock.json' TO='local:./package-lock.json.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/package-lock.json" ./package-lock.json.temp
    echo "Moving 'package-lock.json.temp' to 'package-lock.json'..."
    if [[ -e "./package-lock.json.temp" ]] ; then
        if [[ -e "./package-lock.json" ]] ; then
            echo "Deleting 'package-lock.json'..."
            rm ./package-lock.json
        fi
        echo "Moving 'package-lock.json.temp'..."
        cp ./package-lock.json.temp ./package-lock.json
        rm ./package-lock.json.temp
    else
        echo "ERROR: 'package-lock.json.temp' not found."
        exit 1
    fi
else
    exit 1
fi
##################
echo "Updating 'VERSION.$MANAGER' ..."
if [ -e "./VERSION.temp" ] ; then
    echo "Previous 'VERSION.temp' found. Deleting ..."
    rm VERSION.temp
fi
echo "Run Image, Docker Copy: FROM='container:./VERSION' TO='local:./VERSION.temp' ..."
docker cp "$DOCKER_CONTAINER_ID":"$DOCKER_CONTAINER_WORKDIR/VERSION" "VERSION.temp"
echo "Moving 'VERSION.temp' to 'VERSION.$MANAGER' ..."
if [ -e "./VERSION.temp" ] ; then
    if [ -e "./VERSION.$MANAGER" ] ; then
    echo "Deleting 'VERSION.$MANAGER' ..."
        rm ./VERSION.$MANAGER
        echo "Moving 'VERSION.temp' ..."
    fi
    cp ./VERSION.temp ./VERSION.$MANAGER
    rm ./VERSION.temp
else
    echo "ERROR: 'VERSION.temp' not found."
    exit 1
fi
##################
echo "Recursively deleting all empty (0-length) files not in a 'node_modules' directory."
EMPTY_FILE_COUNT=$(find . -type d -name node_modules -prune -false -o -type f -size 0 | wc -l)
echo "$EMPTY_FILE_COUNT empty files to recursively delete."
if [ $EMPTY_FILE_COUNT -gt 0 ] ; then
    find . -type d -name node_modules -prune -false -o -type f -size 0 | tee /dev/tty | xargs rm
fi
##################
echo "Update complete. [$MANAGER]"
##################
if [ $NO_RECURSE = "TRUE" ] ; then
    echo "Skipping manager update recursion."
    echo "Update complete."
else
    if [ $MANAGER = "yarn" ] ; then
        echo "Backtracking update to npm ..."
        ./scripts/manager.sh --npm --final
    else
        echo "Backtracking update yarn ..."
        ./scripts/manager.sh --yarn --final
    fi
fi
