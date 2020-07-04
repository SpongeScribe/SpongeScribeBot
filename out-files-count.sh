#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
echo "{ \"count\" : [ { \"json\" : \"$(ls ./appdata/out/*.json 2> /dev/null | wc -l)\" }, { \"png\" : \"$(ls ./appdata/out/*.png 2> /dev/null | wc -l)\" } ] }"