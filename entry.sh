#!/usr/bin/env bash

set -ue

confd -onetime -backend env -log-level error

exec "$@"

stellar_core_init_db

function stellar_core_init_db() {
	if [ -f /.db-initialized ]; then
		echo "core db already initialized. continuing on..."
		return 0
	fi

	echo "initializing core db..."

	stellar-core --conf /stellar-core.cfg -newdb

	echo "finished initializing core db"

	touch /.db-initialized
}