#!/usr/bin/env bash

set -eu pipefail

STATE=`curl --silent --max-time 2 http://localhost:11626/info | jq -r .info.state`

if [ "${STATE}" == "Synced!" ]; then
  exit 0
else
  >&2 echo "Expected state \"Synced!\" but got \"${STATE}\""
  exit 1
fi
