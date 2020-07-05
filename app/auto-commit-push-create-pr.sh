#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
if  [ "$1" == "--headless" ]; then
	HEADLESS=0
	shift
else
	HEADLESS=1
fi
git add .
git commit -m "$@"
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
branch_name=${branch_name##refs/heads/}
if  [ -n "$branch_name" ]; then
	git push --set-upstream origin $branch_name
	PR_URL=gh pr create --fill

	if  [ $HEADLESS -eq 0 ]; then
		gh pr view --web # same as link output, don't include in headless scripts, autoselect pr based on your branch
    else
    	echo 'Headless mode. Skipping "gh pr view".'
	fi
else
	echo "ERROR: no branch found. Are you detached?"
fi
return PR_URL
