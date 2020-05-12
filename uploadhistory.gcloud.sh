#!/usr/bin/env bash

set -ue

SOURCE=$1
BUCKET=$2
BUCKET_PATH=$3

DESTINATION=gs://$BUCKET/$BUCKET_PATH

if [ "$BUCKET_PATH" == ".well-known/stellar-history.json" ]; then
	gsutil -q -h "Cache-Control:no-cache, max-age=0" cp $SOURCE $DESTINATION
else
	gsutil -q cp $SOURCE $DESTINATION
fi
