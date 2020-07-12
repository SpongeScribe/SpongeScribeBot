#!/bin/bash
# Author: Drewry Pope
# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/
ROOT_FOLDER="./data"
FOLDER="out"
FOLDER_SPACE_ADJUST=""
ENDNEWLINE="\n"
if  [ "$1" == "--nonewline" ] ; then
    ENDNEWLINE=""
	shift
fi
if  [ "$1" == "--oneline" ] || [ "$1" == "--one-line" ] || [ "$1" == "-1" ] ; then
    NEWLINE=""
    ENDNEWLINE=""
    shift
else
	NEWLINE="\n"
fi
if  [ "$1" == "--nonewline" ] ; then
    ENDNEWLINE=""
	shift
fi
if  [ ! -z "$1" ] ; then
    FOLDER="$1"
fi
if  [ ! -z "$2" ] ; then
    FOLDER_SPACE_ADJUST="$2"
fi
printf "{ \"date\" : \"$(date -Ins)\" $NEWLINE, \"name\" : \"$FOLDER\"$FOLDER_SPACE_ADJUST, \"filemasks\" : [ $NEWLINE{ \"name\" : \"*\", \"count\" : \"$(find $ROOT_FOLDER/$FOLDER/ -type f -name '*' | wc -l)\", \"type\" : \"file\" }, $NEWLINE{ \"name\" : \"*.json\", \"count\" : \"$(find $ROOT_FOLDER/$FOLDER/ -type f -iname '*.json' | wc -l)\", \"type\" : \"file\" }, $NEWLINE{ \"name\" : \"*.png\", \"count\" : \"$(find $ROOT_FOLDER/$FOLDER/ -type f -iname '*.png' | wc -l)\", \"type\" : \"file\" }, $NEWLINE{ \"name\" : \"*.md\", \"count\" : \"$(find $ROOT_FOLDER/$FOLDER/ -type f -name '*.md' | wc -l)\", \"type\" : \"file\" }, $NEWLINE{ \"name\" : \"*\", \"count\" : \"$(find $ROOT_FOLDER/$FOLDER/ -type d -name '*' | wc -l)\", \"type\" : \"directory\" } ] } $ENDNEWLINE"
