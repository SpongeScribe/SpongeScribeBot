#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
if [ -z "$*" ] || [ -z "$1" ] || [ "$1" = "help" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "--h" ] ; then
	printf '\n\nUsage:\n\n./auto-commit-push-create-pr.sh [--headless] <commit-msg> \n\n'
	printf 'Prerequisites: '"'"'git'"'"', '"'"'gh'"'"', at least one new commit. \n\n'
	printf 'This will: \n\n'
	printf '  # \/ adds all files! careful !! \/ <commit-msg> !! \n'
	printf '    git add . \n\n'
	printf '  # \/ you must provide \/ <commit-msg> !! \n'
	printf '    git commit -am <commit-msg> \n\n'
	printf '  # \/ $branch_name pulled automatically \/ \n'
	printf '    git push --set-upstream origin $branch_name \n\n'
	printf '  # \/ \/ pr details automatically filled by commit details. \n'
	printf '    gh pr create --fill \n\n'
	printf '  # \/ \/ if you provide '"'"'--headless'"'"', skip. !! \n'
	printf '    gh pr view --web \n\n'
	printf 'You may be prompted to sign your commits or authenticate to GitHub. \n'
	printf 'Some information about git/gh commands executed will be displayed. \n'
	printf 'At the bottom of the output should be a PR url. \n'
	printf 'Headless mode is recommended if running as root . \n'
	printf 'Headless mode is recommended if browser capabilities are limited. \n\n\n'
else
	branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
	branch_name=${branch_name##refs/heads/}
	if  [ -n "$branch_name" ]; then
		if  [ "$1" = "--headless" ]; then
			HEADLESS=0
			printf 'Headless mode activated. Skipping first argument, skipping browser launch. \n'
			shift
		fi
		printf 'git add \n'
		git add . 2>/dev/null
		printf 'git commit -am \n'
		git commit -am "$*"
		printf 'git push --set-upstream origin $branch_name" \n'
		git push --set-upstream origin $branch_name
		printf 'gh pr create --fill \n'
		gh pr create --fill
		if  [ -z $HEADLESS ]; then
			printf 'gh pr view --web \n'
			gh pr view --web
		fi
	else
		printf 'No "branch_name" found. Are you detached? \n'
	fi
fi
