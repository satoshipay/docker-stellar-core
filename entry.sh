#!/usr/bin/env bash

DB_INITIALIZED="/data/.db-initialized"

function stellar_core_newdb() {
	if [ -f $DB_INITIALIZED ]; then
		echo "core db already initialized. continuing on..."
		return 0
	fi

	echo "initializing core db..."

	stellar-core --conf /stellar-core.cfg -newdb

	echo "finished initializing core db"

	touch $DB_INITIALIZED
}

function stellar_core_newhist() {
	if [ -f /data/.newhist-$1 ]; then
		echo "history archive named $1 is already newed up."
		return 0
	fi

	echo "newing up history archive: $1..."

	stellar-core --newhist

	echo "newing up history archive: $1"

	touch /data/.newhist-$1
}

set -ue

confd -onetime -backend env -log-level error

stellar_core_newdb

exec "$@"