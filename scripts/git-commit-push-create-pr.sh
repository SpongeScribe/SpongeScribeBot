#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
if [ -z "$*" ] || [ -z "$1" ] || [ "$1" = "help" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "--h" ] ; then
	printf '\n\nUsage:\n\n./auto-commit-push-create-pr.sh [--headless] <commit-msg> \n\n'
	printf 'Prerequisites: '"'"'git'"'"', '"'"'gh'"'"' \n\n'
	printf 'This script will: \n\n'
	printf '  # \/  \/ Adds all files. Use care !! !! \n'
	printf '    git add . \n\n'
	printf '  # \/ You must provide \/ <commit-msg> !! \n'
	printf '    git commit -am <commit-msg> \n\n'
	printf '  # \/ $branch_name pulled automatically. \/ \n'
	printf '    git push --set-upstream origin $branch_name \n\n'
	printf '  # \/ \/ PR details automatically filled by commit details. \n'
	printf '    gh pr create --fill \n\n'
	printf '  # \/ \/ Text-only CLI output if you provide '"'"'--headless'"'"'. !! \n'
	printf '    gh pr view --web \n\n'
	printf 'You may be prompted to sign your commits or authenticate to GitHub. \n'
	printf 'Some information about git/gh commands executed will be displayed. \n'
	printf 'At the bottom of the output should be a PR url. \n'
	printf 'Headless mode is recommended if running as root . \n'
	printf 'Headless mode is recommended if browser capabilities are limited. \n'
	printf 'Headless mode is recommended in general because text is better. \n\n\n'
else
	branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
	branch_name=${branch_name##refs/heads/}
	if  [ -n "$branch_name" ]; then
		if  [ "$1" = "--headless" ]; then
			printf 'Headless mode activated. Skipping first argument, text-based gh pr view. \n'
			shift
		else
			GUI_COMMAND=--web
		fi
		printf 'git add \n'
		git add . 2>/dev/null
		printf 'git commit -am \n'
		git commit -am "$*"
		printf 'git push --set-upstream origin $branch_name" \n'
		git push --set-upstream origin $branch_name
		printf 'gh pr create --fill \n'
		gh pr create --fill
		if  [ -z $GUI_COMMAND ]; then
			echo "gh pr view $GUI_COMMAND "
		fi
		gh pr view $GUI_COMMAND
	else
		printf 'No "branch_name" found. Are you detached? \n'
	fi
fi
