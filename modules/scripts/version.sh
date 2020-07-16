#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
rm -f VERSION;
touch VERSION;
printf "node=" >> VERSION;
if command -v npm &> /dev/null
then
	node -v >> VERSION;
else
	printf '\n' >> VERSION;
fi
printf "npm=" >> VERSION;
if command -v npm &> /dev/null
then
	npm -v >> VERSION;
else
	printf '\n' >> VERSION;
fi
printf "yarn=" >> VERSION;
if command -v yarn &> /dev/null
then
	yarn -v >> VERSION;
else
	printf '\n' >> VERSION;
fi
printf "app=" >>VERSION; #TODO:auto-increment
if command -v npm &> /dev/null
then
	npm run version --silent >> VERSION;
fi
printf '\n' >> VERSION;
cat VERSION;

#############################################################################
# these can all be npm scripts, but anything can be an npm script

# # a
# echo $(cat ./package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
# # b
# echo $(cat ./package.json | grep version | head -1 | awk -F= "{ print $2 }" | sed -E 's/(version)|[:,\",]//g' | tr -d '[[:space:]]')

# # c
# echo $(node --eval="process.stdout.write(require('./package.json').version)")

# # d
# node -pe "require('./package.json').version"

# # e
# jq -r .version ./package.json

# # f
# npm run version --silent # add version run-script to scripts: ' "version": "echo $npm_package_version" ' # also could access $npm_package_version any other way

# # g not clean
# npm version

# # if published package, to check published package
# # h
# npm view . version
# # i
# npm show . version

# # j
# awk -F\" '/"version":/ {print $4}' package.json
# # k
# npx -c 'echo "$npm_package_version"'
# # l
# perl -ne 'print "$1\n" if /"version":\s*"(.*?)"/' package.json
# # m
# awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json
# # n
# sed -nr 's/^\s*\"version": "([0-9]{1,}\.[0-9]{1,}.*)",$/\1/p' package.json

# #---

# # npm package example, others exist

# npm i -g json

# # o (requires "npm i -g json")
# json version -a < package.json

# # p (requires "npm i -g json")
# json dependencies -a < package.json | grep : | sed 's/^ *//;s/"//g;s/: /@/;s/,$//'
# # q (requires "npm i -g json")
# json dependencies -a < package.json | grep : | sed 's/[",]//g;s/: /@/;s/,$//'

# # r (requires "npm i -g json")
# json devDependencies -a < package.json | grep : | sed 's/^ *//;s/"//g;s/: /@/;s/,$//'

# # s (requires "npm i -g json")
# json devDependencies -a < package.json | grep : | sed 's/[",]//g;s/: /@/;s/,$//'

# #---
