#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
./scripts/etc/create-data-dirs-and-symlinks.sh
printf "\n# symlinks added by \`./scripts/etc/append-symlinks-to-gitignore.sh\`\n" >> .gitignore;
find . -type l | sed 's|^./||' | xargs -I {} -n1 /bin/echo "/{}" >> .gitignore
