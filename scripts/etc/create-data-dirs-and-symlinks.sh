#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
`pwd`/scripts/etc/delete-symlinks.sh
mkdir -p `pwd`/data/in
mkdir -p `pwd`/data/out
ln -s `pwd`/app/* `pwd`
ln -s `pwd`/app/.* `pwd`
ln -s `pwd`/app/scripts/* `pwd`/scripts
ln -s `pwd`/scripts/* `pwd`
ln -s `pwd`/data `pwd`/app/data
