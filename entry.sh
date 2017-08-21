#!/usr/bin/env bash

set -ue

confd -onetime -backend env -log-level error

exec "$@"

init_stellar_core

function init_stellar_core() {
	if [ -f /.db-initialized ]; then
		echo "core: already initialized"
		return 0
	fi

	stellar-core --conf /stellar-core.cfg -newdb

	touch /.db-initialized
}