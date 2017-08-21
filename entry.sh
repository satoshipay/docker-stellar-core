#!/usr/bin/env bash

set -ue

confd -onetime -backend env -log-level error

exec "$@"

stellar_core_init_db

function stellar_core_init_db() {
	if [ -f /.db-initialized ]; then
		echo "core: already initialized"
		return 0
	fi

	stellar-core --conf /stellar-core.cfg -newdb

	touch /.db-initialized
}