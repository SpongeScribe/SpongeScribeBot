#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
if  [ "$1" -eq "--headless" ]; then
	HEADLESS=0
	shift
	echo "0"
else
	echo "1"
	HEADLESS=1
fi
git add .
git commit -m "$@"
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
branch_name=${branch_name##refs/heads/}
if  [ -n "$branch_name" ]; then
	echo "2"
	git push --set-upstream origin $branch_name
	gh pr create --fill | echo

	if  [ $HEADLESS -eq 0 ]; then
	echo "3"
		gh pr view --web # same as link output, don't include in headless scripts, autoselect pr based on your branch
	fi
else
	echo "ERROR: no branch found. Are you detached?"
fi
