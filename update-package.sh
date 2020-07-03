#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

echo "Update started."

if [[ -f "package.json" ]]; then
	if [[ -n "$1" ]]; then
		echo "Commands present: $*"
		# The 58 NPM commands, as of date: 2020-07-03, npm version: 6.14.5
		if [ "$1" == "access" ] || [ "$1" == "adduser" ] || [ "$1" == "audit" ] || [ "$1" == "bin" ] || [ "$1" == "bugs" ] || [ "$1" == "build" ] || [ "$1" == "bundle" ] || [ "$1" == "cache" ] || [ "$1" == "ci" ] || [ "$1" == "completion" ] || [ "$1" == "config" ] || [ "$1" == "dedupe" ] || [ "$1" == "deprecate" ] || [ "$1" == "dist-tag" ] || [ "$1" == "docs" ] || [ "$1" == "doctor" ] || [ "$1" == "edit" ] || [ "$1" == "explore" ] || [ "$1" == "help-search" ] || [ "$1" == "help" ] || [ "$1" == "hook" ] || [ "$1" == "init" ] || [ "$1" == "install-ci-test" ] || [ "$1" == "install-test" ] || [ "$1" == "install" ] || [ "$1" == "link" ] || [ "$1" == "logout" ] || [ "$1" == "ls" ] || [ "$1" == "npm" ] || [ "$1" == "org" ] || [ "$1" == "outdated" ] || [ "$1" == "owner" ] || [ "$1" == "pack" ] || [ "$1" == "ping" ] || [ "$1" == "prefix" ] || [ "$1" == "profile" ] || [ "$1" == "prune" ] || [ "$1" == "publish" ] || [ "$1" == "rebuild" ] || [ "$1" == "repo" ] || [ "$1" == "restart" ] || [ "$1" == "root" ] || [ "$1" == "run-script" ] || [ "$1" == "search" ] || [ "$1" == "shrinkwrap" ] || [ "$1" == "star" ] || [ "$1" == "stars" ] || [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "team" ] || [ "$1" == "test" ] || [ "$1" == "token" ] || [ "$1" == "uninstall" ] || [ "$1" == "unpublish" ] || [ "$1" == "update" ] || [ "$1" == "version" ] || [ "$1" == "view" ] || [ "$1" == "whoami" ] ; then
			COMMANDS="$*"
		# Else assuming trying to install something.
		else
			echo "Script did not recognize '$1' as npm command."
			echo "Assuming list of packages, attempting 'npm install'"
			COMMANDS="install $*"
		fi
	else
		echo "No commands present. Running 'npm update'..."
		COMMANDS="update"
	fi

	echo "Updating package.json..."

	if [[ -f "package.json.temp" ]]; then
		echo "Previous 'package.json.temp' found. Deleting..."
		rm package.json.temp
	fi

	echo "Build Image, Run Image, Copy File: container:'package.json' to local:'package.json.temp'"
	docker cp $(docker run -d $(docker build . -q --target install) "$COMMANDS"; sleep 2):/usr/local/app/package.json ./package.json.temp

	echo "Updating package-lock.temp.json..."

	if [[ -f "package-lock.json.temp" ]]; then
		echo "Previous 'package-lock.json.temp' found. Deleting..."
		rm package-lock.json.temp
	fi

	echo "Build Image, Run Image, Copy File: container:'package-lock.json' to local:'package-lock.json.temp'"
	docker cp $(docker run -d $(docker build . -q --target install) "$COMMANDS"; sleep 2):/usr/local/app/package-lock.json ./package-lock.json.temp

	echo "Moving temp files to permanent locations..."

	echo "Moving 'package.json.temp' to 'package.json'..."

	if [[ -f "package.json.temp" ]]; then
		echo "Deleting 'package.json'..."
		rm package.json
		echo "Moving 'package.json.temp'..."
		mv package.json.temp package.json
	else
		echo "ERROR: 'package.json.temp' not found."
		exit
	fi

	echo "Moving 'package-lock.json.temp' to 'package-lock.json'..."

	if [[ -f "package-lock.json.temp" ]]; then
		echo "Deleting 'package-lock.json'..."
		rm -f package-lock.json
		echo "Moving 'package-lock.json.temp'..."
		mv package-lock.json.temp package-lock.json
	else
		echo "ERROR: 'package-lock.json.temp' not found."
		exit
	fi
else
	echo "ERROR: 'package.json' not found."
	exit
fi
echo "Update complete."
