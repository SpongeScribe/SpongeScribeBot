#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
mkdir -p `pwd`/scripts/etc
touch `pwd`/scripts/etc/delete-symlinks.sh
`pwd`/scripts/etc/delete-symlinks.sh
mkdir -p `pwd`/data/in
mkdir -p `pwd`/data/out
find -type f -xtype f -not -path "./.git*" -name '*.sh' -exec sh -c 'ln -s ./$(basename {}) `pwd`/$(echo "{}" | rev | cut -c 4- | rev)' \;
mkdir -p `pwd`/app/scripts
ln -s ./app/* `pwd`
ln -s ./app/.* `pwd`
ln -s ../app/scripts/ `pwd`/scripts/scripts
cd scripts
ln -s ./scripts/* `pwd`
cd ..
ln -s ./scripts/* `pwd`
mkdir -p `pwd`app/data
ln -s `pwd`/data `pwd`/app/data

find -type l -not -path "./.git*" -name '*.sh' -exec sh -c 'cp -P ./{} `pwd`/$(echo "{}" | rev | cut -c 4- | rev)' \;

ln -s ./scripts/etc/create-data-dirs-and-symlinks.sh init
