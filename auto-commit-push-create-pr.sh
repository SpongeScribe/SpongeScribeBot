#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
if  [ "$1" = "--headless" ]; then
	HEADLESS=0
	shift
fi
git add . 2>/dev/null
git commit -am "$*"
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
branch_name=${branch_name##refs/heads/}
if  [ -n "$branch_name" ]; then
	git push --set-upstream origin $branch_name &>/dev/null
	gh pr create --fill  2>/dev/null
	if  [ "$HEADLESS" = 0 ]; then
		gh pr view --web 2>/dev/null
	fi
fi
