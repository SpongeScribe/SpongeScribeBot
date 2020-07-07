#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
find -type l -delete
ln -s `pwd`/app/* .
ln -s `pwd`/app/scripts/* scripts
