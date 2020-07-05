#!/bin/bash
# Author: Drewry Pope
if  [ "$1" = "--headless" ]; then
	HEADLESS=0
	shift
fi
git add . 2>/dev/null
git commit -m "$@" 2>/dev/null
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
branch_name=${branch_name##refs/heads/}
if  [ -n "$branch_name" ]; then
	git push --set-upstream origin $branch_name 2>/dev/null
	gh pr create --fill  2>/dev/null
	if  [ "$HEADLESS" = 0 ]; then
		echo "1" > out # gh pr view --web

	else
		echo "22" > out # gh pr view --web
	fi
fi
