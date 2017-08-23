#!/usr/bin/env bash

DB_INITIALIZED="/data/.db-initialized"

set -ue

function stellar_core_newhist() {
	if [ -f /data/.newhist-$1 ]; then
		echo "history archive named $1 is already newed up."
		return 0
	fi

	echo "newing up history archive: $1..."

	stellar-core --newhist $1

	echo "newing up history archive: $1"

	touch /data/.newhist-$1
}

function stellar_core_init_db() {
  local DB_INITIALIZED="/data/.db-initialized"

  if [ -f $DB_INITIALIZED ]; then
    echo "core db already initialized. continuing on..."
    return 0
  fi

  echo "initializing core db..."

  stellar-core --conf /stellar-core.cfg -newdb

  echo "finished initializing core db"

  touch $DB_INITIALIZED
}

confd -onetime -backend env -log-level error

#attempt to init the db (if it does not yet exist)
stellar_core_init_db

#attempt to new any history archives that have not yet been newed.
jq -c 'keys[]' $HISTORY | while read archive_name; do
    if "$(echo "$archive_name" | jq 'has("put")')" == "true"; then
        stellar_core_newhist $archive_name
    fi
done

exec "$@"
