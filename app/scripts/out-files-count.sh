#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
echo "{ \"count\" : [ { \"*\" : \"$(ls ./data/out/* 2> /dev/null | wc -l)\" }, { \"*.json\" : \"$(ls ./data/out/*.json 2> /dev/null | wc -l)\" }, { \"*.png\" : \"$(ls ./data/out/*.png 2> /dev/null | wc -l)\" }, { \"*.md\" : \"$(ls ./data/out/*.md 2> /dev/null | wc -l)\" }, { \"-ar *\" : \"$(ls -ar ./data/out/* 2> /dev/null | wc -l)\" } ] }"
