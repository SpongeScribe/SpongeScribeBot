#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -x
mkdir -p scripts/etc
touch scripts/etc/delete-symlinks.sh
./scripts/etc/delete-symlinks.sh
mkdir -p data/in
mkdir -p data/out
mkdir -p data/secrets
mkdir -p data/logs
find . -type f -xtype f -not -path "./modules/*" -not -path "*/data/*" -not -path "*/.yarn/*" -not -path "*/.git/*" -not -path "*/node_modules/*" -name '*.sh' -exec sh -c 'ln -s $(basename {}) $(echo "{}" | rev | cut -c 4- | rev)' \;
mkdir -p app/scripts
ln -s ../app/scripts/ scripts/scripts
cd scripts
ln -s scripts/* ./
cd ..
rm scripts/scripts
ln -s scripts/* ./
ln -s ../app/scripts/ scripts/scripts
find ./ -type d -not -path "./*/*" -not -path "./modules" -not -path "*/data" -not -path "./.yarn*" -not -path "./.git*" -not -path "*/node_modules" -not -path "./" -exec sh -c "find {} -type f -name \".*\"" \; | xargs -I % sh -c 'ln -s % ./'
find ./ -type d -not -path "./*/*" -not -path "./modules" -not -path "*/data" -not -path "./.yarn*" -not -path "./.git*" -not -path "*/node_modules" -not -path "./" -exec sh -c "find {} -type f -name \"*.js\"" \; | xargs -I % sh -c 'ln -s % ./'
ln -s ../data app/data
ln -s package.json package
ln -s scripts/etc/create-data-dirs-and-symlinks.sh init
