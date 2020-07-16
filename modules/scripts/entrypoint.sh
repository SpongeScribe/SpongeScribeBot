#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
set -ex
echo "entrypoint.sh start."
echo "PARAMETERS=[[$@]]"
if [ -z "$@" ] ; then
	if command -v npm &> /dev/null
	then
		echo "npm found, using 'npm run-script start' action."
		if npm run | grep -q "$1"; then
			npm run-script "$@"
		else
			npm run-script start "$@"
		fi
	elif command -v node &> /dev/null
	then
	    echo "npm not found, using 'node' command"
	    node "$@"
	# order chosen because: https://stackoverflow.com/questions/36002413/conventions-for-app-js-index-js-and-server-js-in-node-js
	elif [ -s "$1" ]
	then
		echo "npm and node not found, trying to execute '$1' ..."
		"$@"
	elif [ -s Makefile ] && command -v make &> /dev/null
	then
		echo "Makefile present, trying make ..."]
		make
		"$@"
	else
		echo "ERROR: npm, node, server.js, index.js, app.js, Makefile are not present."
		echo "ERROR: Unknown entrypoint condition."
		echo "ERROR: Trying 'sleep 10' ..."
		if command -v sleep &> /dev/null
		then
			sleep 10
	    else
			echo "ERROR: 'command' reports 'sleep not found."
			echo "ERROR: Trying 'sleep 10' anyways ..."
			sleep 10
			echo "ERROR: 'sleep 10' complete."
			echo "ERROR: Something is wrong ..."
			echo "ERROR: Exiting ..."
			exit 1
			echo "ERROR: Past 'exit 1' ..."
			exit 99999999999
		fi
	fi
fi
if command -v npm &> /dev/null
then
	echo "npm found, using 'npm run-script start' action."
	npm run-script "$@"
elif command -v node &> /dev/null
then
    echo "npm not found, using 'node' command"
    node index.js
# order chosen because: https://stackoverflow.com/questions/36002413/conventions-for-app-js-index-js-and-server-js-in-node-js
elif [ -s server.js ]
then
	echo "npm and node not found, trying to execute 'server.js' ..."
	./server.js
elif [ -s index.js ]
then
	echo "npm and node not found, trying to execute 'index.js' ..."
	./index.js
elif [ -s app.js ]
then
	echo "npm and node not found, trying to execute 'app.js' ..."
	./app.js
elif [ -s Makefile ] && command -v make &> /dev/null
then
	echo "Makefile present, trying make ..."]
	make
else
	echo "ERROR: npm, node, server.js, idnex.js, app.js, Makefile are not present."
	echo "ERROR: Unknown entrypoint condition."
	echo "ERROR: Trying 'sleep 10' ..."
	if command -v sleep &> /dev/null
	then
		sleep 10
    else
		echo "ERROR: 'command' reports 'sleep not found."
		echo "ERROR: Trying 'sleep 10' anyways ..."
		sleep 10
		echo "ERROR: 'sleep 10' complete."
		echo "ERROR: Something is wrong ..."
		echo "ERROR: Exiting ..."
		exit 1
		echo "ERROR: Past 'exit 1' ..."
		exit 99999999999
	fi
fi
echo "entrypoint.sh complete."
exit 0
