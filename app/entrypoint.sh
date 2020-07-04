#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
IMAGE_TEXT="$*"
export IMAGE_TEXT=$IMAGE_TEXT
echo "IMAGE_TEXT=$IMAGE_TEXT" | tee --append .env
npm run start
