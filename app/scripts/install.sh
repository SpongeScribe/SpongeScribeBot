#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex

echo "Check first argument."
if [[ -n "$1" ]]; then
	echo "Commands present: $@"
	# The 79 NPM commands plus some flags, as of date: 2020-07-03, npm version: 6.14.5
	if  [ "$1" == "update" ] || [ "$1" == "install" ] || [ "$1" == "uninstall" ] || [ "$1" == "-v" ] || [ "$1" == "-h" ] ||  [ "$1" == "-help" ] ||  [ "$1" == "--help" ] || [ "$1" == "--version" ] || [ "$1" == "" ] || [ "$1" == "access" ] || [ "$1" == "adduser" ] || [ "$1" == "audit" ] || [ "$1" == "bin" ] || [ "$1" == "bugs" ] || [ "$1" == "c" ] || [ "$1" == "cache" ] || [ "$1" == "ci" ] || [ "$1" == "cit" ] || [ "$1" == "clean-install" ] || [ "$1" == "clean-install-test" ] || [ "$1" == "completion" ] || [ "$1" == "config" ] || [ "$1" == "create" ] || [ "$1" == "ddp" ] || [ "$1" == "dedupe" ] || [ "$1" == "deprecate" ] || [ "$1" == "dist-tag" ] || [ "$1" == "docs" ] || [ "$1" == "doctor" ] || [ "$1" == "edit" ] || [ "$1" == "explore" ] || [ "$1" == "fund" ] || [ "$1" == "get" ] || [ "$1" == "help" ] || [ "$1" == "help-search" ] || [ "$1" == "hook" ] || [ "$1" == "i" ] || [ "$1" == "init" ] || [ "$1" == "install-ci-test" ] || [ "$1" == "install-test" ] || [ "$1" == "it" ] || [ "$1" == "link" ] || [ "$1" == "list" ] || [ "$1" == "ln" ] || [ "$1" == "login" ] || [ "$1" == "logout" ] || [ "$1" == "ls" ] || [ "$1" == "org" ] || [ "$1" == "outdated" ] || [ "$1" == "owner" ] || [ "$1" == "pack" ] || [ "$1" == "ping" ] || [ "$1" == "prefix" ] || [ "$1" == "profile" ] || [ "$1" == "prune" ] || [ "$1" == "publish" ] || [ "$1" == "rb" ] || [ "$1" == "rebuild" ] || [ "$1" == "repo" ] || [ "$1" == "restart" ] || [ "$1" == "root" ] || [ "$1" == "run" ] || [ "$1" == "run-script" ] || [ "$1" == "s" ] || [ "$1" == "se" ] || [ "$1" == "search" ] || [ "$1" == "set" ] || [ "$1" == "shrinkwrap" ] || [ "$1" == "star" ] || [ "$1" == "stars" ] || [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "t" ] || [ "$1" == "team" ] || [ "$1" == "test" ] || [ "$1" == "token" ] || [ "$1" == "tst" ] || [ "$1" == "un" ] || [ "$1" == "unpublish" ] || [ "$1" == "unstar" ] || [ "$1" == "up" ] || [ "$1" == "v" ] || [ "$1" == "version" ] || [ "$1" == "view" ] || [ "$1" == "whoami" ]; then
		COMMAND="$1"
		shift
	# Else assuming trying to install something.
	else
		echo "Script did not recognize '$1' as npm command."
		echo "Assuming list of packages, attempting 'npm install'"
		COMMAND="install"
	fi
else
	echo "No commands present. Running 'npm update'..."
	COMMAND="update"
fi

echo "Run npm command."
npm $COMMAND "$@"

echo 'Run version script'.
./version.sh

echo 'All done!'.

echo 'Run sleep script'.
echo 'Default 5 Minutes'.
./sleep.sh
