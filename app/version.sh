#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
rm -f ./version;
touch version;

printf "node=" >> version;
node -v >> version;

printf "npm=" >>version;
npm -v >> version;

printf "app=" >>version;
#TODO:auto-incr, pull from package.json (choose option from version-check.sh), delete appversion file.
cat appversion >> version;
echo '' >> version;

cat version;
