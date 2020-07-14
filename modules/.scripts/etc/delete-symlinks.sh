#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -x
find -type l -not -path "*/data/*" -not -path "*/.yarn/*" -not -path "*/.git/*" -not -path "*/node_modules/*" -delete
