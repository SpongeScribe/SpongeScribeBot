#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
WORKDIR=/usr/local/app
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
# APP="sleep-atomic"
# if  [ "$1" = "--app" ] || [ "$1" = "-a" ] ; then
    # shift
    APP=$1
    shift
# fi
if [ -z "$MODULE_ROOT" ] ; then
    MODULE_ROOT="./modules"
fi
if [ -z "$APP_PATH" ] ; then
    APP_PATH="$MODULE_ROOT/$APP"
fi
if [ -z "$TARGET" ] ; then
    TARGET="install"
fi
##################
if [[ ! -e "$APP_PATH/package.json" ]] ; then
    echo "ERROR: 'package.json' not found."
    if [[ -s "$APP_PATH/package.json.temp" ]] ; then
        echo "Found: 'package.json.temp'"
        echo "Attempting to continue with 'package.json.temp'."
        echo "Copying 'package.json.temp' to 'package.json' ..."
        cp $APP_PATH/package.json.temp $APP_PATH/package.json
    else
        echo "ERROR: 'package.json.temp' not found."
        exit 1
    fi
fi
if [[ ! -e "$APP_PATH/.yarnrc" ]] ; then
    echo "ERROR: '.yarnrc' not found."
    if [[ -s "$APP_PATH/.yarnrc.temp" ]] ; then
        echo "Found: '.yarnrc.temp'"
        echo "Attempting to continue with '.yarnrc.temp'."
        echo "Copying '.yarnrc.temp' to '.yarnrc' ..."
        cp $APP_PATH/.yarnrc.temp $APP_PATH/.yarnrc
    fi
fi
if [[ ! -e "$APP_PATH/.yarnrc.yml" ]] ; then
    echo "ERROR: '.yarnrc.yml' not found."
    if [[ -s "$APP_PATH/.yarnrc.yml.temp" ]] ; then
        echo "Found: '.yarnrc.yml.temp'"
        echo "Attempting to continue with '.yarnrc.yml.temp'."
        echo "Moving '.yarnrc.yml.temp' to '.yarnrc.yml' ..."
        mv $APP_PATH/.yarnrc.yml.temp $APP_PATH/.yarnrc.yml
    fi
fi
if [[ ! -d "$APP_PATH/.yarn/" ]] ; then
    echo "ERROR: '.yarn/' not found."

    if [[ -d "$APP_PATH/.yarn.temp/" ]] ; then
        echo "Found: '.yarn.temp/'"
        echo "Attempting to continue with '.yarn.temp/'."
        echo "Moving '.yarn.temp/' to '.yarn/' ..."
        mv $APP_PATH/.yarn.temp/ $APP_PATH/.yarn/
    else
        echo "ERROR: '.yarn.temp/' not found."
        echo "Attempting to continue with clean run."

        echo "Creating empty '.yarn/' directory for Dockerfile ..."
        mkdir $APP_PATH/.yarn/

        if [[ -e "$APP_PATH/.yarnrc" ]] ; then
            echo "Found: '.yarnrc'"
            echo "Moving '.yarnrc' to '.yarnrc.clean.temp' ..."
            if [[ -s "$APP_PATH/.yarnrc.clean.temp" ]] ; then
                echo "ERROR: Previous '.yarnrc.clean.temp' found. Exiting ..."
                exit 1
            elif [[ -e "$APP_PATH/.yarnrc.clean.temp" ]] ; then
                rm $APP_PATH/yarnrc.clean.temp
            fi
            mv $APP_PATH/.yarnrc $APP_PATH/.yarnrc.clean.temp
            echo "This file must be cleaned up manually: '.yarnrc.clean.temp'"
        fi

        if [[ -e "$APP_PATH/.yarnrc.yml" ]] ; then
            echo "Found: '.yarnrc.yml'"
            echo "Moving '.yarnrc.yml' to '.yarnrc.yml.clean.temp' ..."
            if [[ -s "$APP_PATH/.yarnrc.yml.clean.temp" ]] ; then
                echo "ERROR: Previous '.yarnrc.yml.clean.temp' found. Exiting ..."
                exit 1
            elif [[ -e "$APP_PATH/.yarnrc.yml.clean.temp" ]] ; then
                rm $APP_PATH/yarnrc.yml.clean.temp
            fi
            mv $APP_PATH/.yarnrc.yml $APP_PATH/.yarnrc.yml.clean.temp
            echo "This file must be cleaned up manually: '.yarnrc.yml.clean.temp'"
        fi
    fi
fi
##################
echo "Build Install Image ..."
docker build --build-arg MANAGER="$MANAGER" . --target install
echo "Run Install Image, Kill Log Follow When Image Sleeps ..."
DOCKER_CONTAINER_ID=$(docker run -d $(docker build --build-arg WORKDIR="$WORKDIR" --build-arg MANAGER="$MANAGER" --build-arg APP="$APP" . -q --target $TARGET) "$@");
{ sed /sleep\ /q; kill $!; } < <(exec docker logs --details --follow --timestamps "$DOCKER_CONTAINER_ID")
##################
echo "Updating 'package.json' ..."
if [[ -e "$APP_PATH/package.json.temp" ]] ; then
    echo "Previous 'package.json.temp' found. Deleting ..."
    rm $APP_PATH/package.json.temp
fi
echo "Docker Copy: FROM='container:$WORKDIR/package.json' TO='local:$APP_PATH/package.json.temp' ..."
docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/package.json" $APP_PATH/package.json.temp
echo "Moving 'package.json.temp' to 'package.json' ..."
if [[ -e "$APP_PATH/package.json.temp" ]] ; then
    if [[ -e "$APP_PATH/package.json" ]] ; then
        echo "Deleting 'package.json'..."
        rm $APP_PATH/package.json
    fi
    echo "Moving 'package.json.temp' ..."
    cp $APP_PATH/package.json.temp $APP_PATH/package.json
    rm $APP_PATH/package.json.temp
else
    echo "ERROR: 'package.json.temp' not found."
    exit 1
fi
##################
if [ "$MANAGER" == "yarn" ] ; then
    echo "Updating 'yarn.lock' ..."
    if [[ -e "$APP_PATH/yarn.lock.temp" ]] ; then
        echo "Previous 'yarn.lock.temp' found. Deleting ..."
        rm -r $APP_PATH/yarn.lock.temp
    fi
    echo "Docker Copy: FROM='container:$WORKDIR/yarn.lock' TO='local:$APP_PATH/yarn.lock.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/yarn.lock" $APP_PATH/yarn.lock.temp
    echo "Moving 'yarn.lock.temp' to 'yarn.lock' ..."
    if [[ -e "$APP_PATH/yarn.lock.temp" ]] ; then
        if [[ -e "$APP_PATH/yarn.lock" ]] ; then
            echo "Deleting 'yarn.lock'..."
            rm $APP_PATH/yarn.lock
        fi
        echo "Moving 'yarn.lock.temp' ..."
        cp $APP_PATH/yarn.lock.temp $APP_PATH/yarn.lock
        rm -r $APP_PATH/yarn.lock.temp
    else
        echo "ERROR: 'yarn.lock.temp' not found."
        exit 1
    fi

    echo "Updating '.yarn/' ..."
    if [[ -e "$APP_PATH/.yarn.temp/" ]] ; then
        echo "Previous '.yarn.temp/' found. Deleting ..."
        rm -r $APP_PATH/.yarn.temp/
    fi
    echo "Docker Copy: FROM='container:$WORKDIR/.yarn' TO='local:$APP_PATH/.yarn.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/.yarn/" $APP_PATH/.yarn.temp/
    echo "Moving '.yarn.temp/' to '.yarn/'..."
    if [[ -e "$APP_PATH/.yarn.temp/" ]] ; then
        if [[ -d "$APP_PATH/.yarn/" ]] ; then
            echo "Deleting '.yarn/'..."
            rm -r $APP_PATH/.yarn/
        fi
        echo "Moving '.yarn.temp/' ..."
        cp -r $APP_PATH/.yarn.temp/ $APP_PATH/.yarn/
        rm -r $APP_PATH/.yarn.temp/
    else
        echo "ERROR: '.yarn.temp/' not found."
        exit 1
    fi

    echo "Updating '.yarnrc' ..."
    if [[ -e "$APP_PATH/.yarnrc.temp" ]] ; then
        echo "Previous '.yarnrc.temp' found. Deleting ..."
        rm $APP_PATH/.yarnrc.temp
    fi
    echo "Docker Copy: FROM='container:$WORKDIR/.yarnrc' TO='local:$APP_PATH/.yarnrc.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/.yarnrc" $APP_PATH/.yarnrc.temp
    echo "Moving '.yarnrc.temp' to '.yarnrc' ..."
    if [[ -e "$APP_PATH/.yarnrc.temp" ]] ; then
        if [[ -e "$APP_PATH/.yarnrc" ]] ; then
            echo "Deleting '.yarnrc' ..."
            rm $APP_PATH/.yarnrc
        fi
        echo "Moving '.yarnrc.temp' ..."
        cp $APP_PATH/.yarnrc.temp $APP_PATH/.yarnrc
        rm $APP_PATH/.yarnrc.temp
    else
        echo "ERROR: '.yarnrc.temp' not found."
        exit 1
    fi

    echo "Updating '.yarnrc.yml' ..."
    if [[ -e "$APP_PATH/.yarnrc.yml.temp" ]] ; then
        echo "Previous '.yarnrc.yml.temp' found. Deleting ..."
        rm $APP_PATH/.yarnrc.yml.temp
    fi
    echo "Docker Copy: FROM='container:$WORKDIR/.yarnrc.yml' TO='local:$APP_PATH/.yarnrc.yml.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/.yarnrc.yml" $APP_PATH/.yarnrc.yml.temp
    echo "Moving '.yarnrc.yml.temp' to '.yarnrc.yml' ..."
    if [[ -e "$APP_PATH/.yarnrc.yml.temp" ]] ; then
        if [[ -e "$APP_PATH/.yarnrc.yml" ]] ; then
            echo "Deleting '.yarnrc.yml' ..."
            rm $APP_PATH/.yarnrc.yml
        fi
        echo "Moving '.yarnrc.yml.temp' ..."
        cp $APP_PATH/.yarnrc.yml.temp $APP_PATH/.yarnrc.yml
        rm $APP_PATH/.yarnrc.yml.temp
    else
        echo "ERROR: '.yarnrc.yml.temp' not found."
        exit 1
    fi
##################
elif [ "$MANAGER" == "npm" ] ; then
    echo "Updating 'package-lock.json' ..."
    if [[ -e "$APP_PATH/package-lock.json.temp" ]] ; then
        echo "Previous 'package-lock.json.temp' found. Deleting ..."
        rm $APP_PATH/package-lock.json.temp
    fi
    echo "Docker Copy: FROM='container:$WORKDIR/package-lock.json' TO='local:$APP_PATH/package-lock.json.temp' ..."
    docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/package-lock.json" $APP_PATH/package-lock.json.temp
    echo "Moving 'package-lock.json.temp' to 'package-lock.json'..."
    if [[ -e "$APP_PATH/package-lock.json.temp" ]] ; then
        if [[ -e "$APP_PATH/package-lock.json" ]] ; then
            echo "Deleting 'package-lock.json'..."
            rm $APP_PATH/package-lock.json
        fi
        echo "Moving 'package-lock.json.temp'..."
        cp $APP_PATH/package-lock.json.temp $APP_PATH/package-lock.json
        rm $APP_PATH/package-lock.json.temp
    else
        echo "ERROR: 'package-lock.json.temp' not found."
        exit 1
    fi
else
    exit 1
fi
##################
echo "Updating 'VERSION.$MANAGER' ..."
if [ -e "$APP_PATH/VERSION.temp" ] ; then
    echo "Previous 'VERSION.temp' found. Deleting ..."
    rm VERSION.temp
fi
echo "Run Image, Docker Copy: FROM='container:$WORKDIR/VERSION' TO='local:$APP_PATH/VERSION.temp' ..."
docker cp "$DOCKER_CONTAINER_ID":"$WORKDIR/VERSION" "$APP_PATH/VERSION.$MANAGER.temp"
echo "Moving 'VERSION.$MANAGER.temp' to 'VERSION.$MANAGER' ..."
if [ -e "$APP_PATH/VERSION.$MANAGER.temp" ] ; then
    if [ -e "$APP_PATH/VERSION.$MANAGER" ] ; then
    echo "Deleting 'VERSION.$MANAGER' ..."
        rm $APP_PATH/VERSION.$MANAGER
        echo "Moving 'VERSION.$MANAGER.temp' ..."
    fi
    cp $APP_PATH/VERSION.$MANAGER.temp $APP_PATH/VERSION.$MANAGER
    rm $APP_PATH/VERSION.$MANAGER.temp
else
    echo "ERROR: 'VERSION.$MANAGER.temp' not found."
    exit 1
fi
##################
# echo "Recursively deleting all empty (0-length) files not in a 'node_modules' directory."
# EMPTY_FILE_COUNT=$(find . -type d -name node_modules -prune -false -o -type f -size 0 | wc -l)
# echo "$EMPTY_FILE_COUNT empty files to recursively delete."
# if [ $EMPTY_FILE_COUNT -gt 0 ] ; then
#     find . -type d -name node_modules -prune -false -o -type f -size 0 | tee /dev/tty | xargs rm
# fi
##################
echo "Update complete. [$MANAGER]"
##################
if [ $NO_RECURSE == "TRUE" ] ; then
    echo "Skipping manager update recursion."
    echo "Update complete."
else
    if [ $MANAGER == "yarn" ] ; then
        echo "Backtracking update to npm ..."
        ./scripts/manager.sh --npm --final $APP
    else
        echo "Backtracking update yarn ..."
        ./scripts/manager.sh --yarn --final $APP
    fi
fi
