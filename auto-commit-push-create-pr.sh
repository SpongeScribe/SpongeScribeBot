#!/bin/bash
# Author: Drewry Pope
set -ex
HEADLESS=$1
if  [ "$HEADLESS" -eq "--headless" ]; then
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
	gh pr create --fill
	if  [ "$HEADLESS" ]; then
		gh pr view --web # same as link output, don't include in headless scripts, autoselect pr based on your branch
	fi
fi
