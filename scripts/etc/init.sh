#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
cat ../.env > .env
cat ../.env.twitter > .env.twitter
cat ../.env.twitter >> .env
