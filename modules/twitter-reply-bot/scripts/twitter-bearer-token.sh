#!/bin/bash
# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
set -ex
mkdir -p data/secrets
INPUT_DIR=./data/secrets
touch .env .env.twitter
BEARER_TOKEN_FILE_EXTENSION=key.json

while [ -z "$BEARER_TOKEN" ]
do
	BEARER_TOKEN_FILE_PREFIX="twitter.bearer.token.`date --iso-8601`."
	BEARER_TOKEN_FILE_GLOB="$BEARER_TOKEN_FILE_PREFIX*.$BEARER_TOKEN_FILE_EXTENSION"
	BEARER_TOKEN_FILE_COUNT=$(find "$INPUT_DIR" -name "$BEARER_TOKEN_FILE_GLOB" | wc -l)
	if [ "$BEARER_TOKEN_FILE_COUNT" -eq 0 ]; then
		BEARER_TOKEN=-1
	    echo "No recent bearer token exists.."
	    eval $(cat .env .env.twitter | sed 's/#.*//g' | xargs) \
	      curl -u '$TWITTER_CONSUMER_KEY:$TWITTER_CONSUMER_SECRET' \
	        --data 'grant_type=client_credentials' \
	          'https://api.twitter.com/oauth2/token' > "$INPUT_DIR/$BEARER_TOKEN_FILE_PREFIX`uuid`.$BEARER_TOKEN_FILE_EXTENSION"
	 elif [ "$BEARER_TOKEN_FILE_COUNT" -eq 1 ]; then
	    echo "Recent bearer token exists. Using recent bearer token."
	 else
	 	echo "Too many bearer tokens exist!! Using most recent bearer token."
	fi
	BEARER_TOKEN_FILE=$(find "$INPUT_DIR" -name "$BEARER_TOKEN_FILE_GLOB" -type f -printf '%TFT%TT %p\n' | sort | tail -1 | cut -f2- -d' ')

	echo "$BEARER_TOKEN_FILE"
	if [ -z "$BEARER_TOKEN_FILE" ]; then
		echo "Error. Exiting.."
		BEARER_TOKEN=-1
	else
		BEARER_TOKEN_FILE_CONTENTS=$(cat "$BEARER_TOKEN_FILE")
		AUTHENTICITY_TOKEN_ERROR='{"errors":[{"code":99,"message":"Unable to verify your credentials","label":"authenticity_token_error"}]}'
		if [ "$BEARER_TOKEN_FILE_CONTENTS" == "$AUTHENTICITY_TOKEN_ERROR" ]; then
			echo "Invalid token file. Moving file.."
			mv "$BEARER_TOKEN_FILE" "$(echo "$BEARER_TOKEN_FILE" | rev | cut -c 6- | rev).invalid.json"
			echo "Invalid token file moved. Trying again.."
		else
			echo "Valid file found.."
			BEARER_TOKEN="$BEARER_TOKEN_FILE_CONTENTS"
		fi
		echo "$BEARER_TOKEN_FILE_CONTENTS"
	fi
done

echo "$BEARER_TOKEN"
