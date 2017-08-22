#!/usr/bin/env bash

DB_INITIALIZED="/data/.db-initialized"

function stellar_core_init_db() {
	if [ -f $DB_INITIALIZED ]; then
		echo "core db already initialized. continuing on..."
		return 0
	fi

	echo "initializing core db..."

	stellar-core --conf /stellar-core.cfg -newdb

	echo "finished initializing core db"

	touch $DB_INITIALIZED
}

set -ue

confd -onetime -backend env -log-level error

stellar_core_init_db

exec "$@"