#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
mkdir -p scripts/etc
touch scripts/etc/delete-symlinks.sh
./scripts/etc/delete-symlinks.sh
mkdir -p data/in
mkdir -p data/out
find -type f -xtype f -not -path "./.git*" -name '*.sh' -exec sh -c 'ln -s $(basename {}) $(echo "{}" | rev | cut -c 4- | rev)' \;
mkdir -p app/scripts
ln -s app/* `pwd`
ln -s app/.* `pwd`
ln -s ../app/scripts/ scripts/scripts
cd scripts
ln -s scripts/* `pwd`
cd ..
ln -s scripts/* `pwd`
ln -s ../data app/data
find -type l -not -path "./.git*" -name '*.sh' -exec sh -c 'cp -P ./{} $(echo "{}" | rev | cut -c 4- | rev)' \;
ln -s package.json package
ln -s scripts/etc/create-data-dirs-and-symlinks.sh init
