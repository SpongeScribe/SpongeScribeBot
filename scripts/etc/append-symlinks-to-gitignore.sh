#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
`pwd`/scripts/create-data-dirs-and-symlinks.sh
printf "\n# symlinks added by \`./scripts/init-local-app-symlinks.sh\`\n" >> .gitignore;
find . -type l | sed 's|^./||' >> .gitignore
