#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
echo "{ \"count\" : [ { \"*\" : \"$(ls ./data/in/* 2> /dev/null | wc -l)\" }, { \"*.json\" : \"$(ls ./data/in/*.json 2> /dev/null | wc -l)\" }, { \"*.png\" : \"$(ls ./data/in/*.png 2> /dev/null | wc -l)\" }, { \"*.md\" : \"$(ls ./data/in/*.md 2> /dev/null | wc -l)\" }, { \"-ar *\" : \"$(ls -ar ./data/in/* 2> /dev/null | wc -l)\" } ] }"
