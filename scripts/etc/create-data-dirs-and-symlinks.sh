#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
`pwd`/scripts/etc/delete-symlinks.sh
mkdir -p `pwd`/data/in
mkdir -p `pwd`/data/out
find -type f -xtype f -not -path "./.git*" -name '*.sh' -exec sh -c 'ln -s `pwd`/{} `pwd`/$(echo "{}" | rev | cut -c 4- | rev)' \;
ln -s `pwd`/app/* `pwd`
ln -s `pwd`/app/.* `pwd`
ln -s `pwd`/app/scripts/* `pwd`/scripts
ln -s `pwd`/scripts/* `pwd`
ln -s `pwd`/data `pwd`/app/data

find -type l -not -path "./.git*" -name '*.sh' -exec sh -c 'cp -P `pwd`/{} `pwd`/$(echo "{}" | rev | cut -c 4- | rev)' \;
