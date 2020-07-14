#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
if [ "$1" == "--yarn" ] || [ "$1" == "yarn" ] ; then
    YARN="yarn"
    shift
fi
rm -f package
$YARN npm pack && tar -xvzf *.tgz && rm -rf package *.tgz
ln -s ./package.json ./package
