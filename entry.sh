#!/usr/bin/env bash

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

set -ue

confd -onetime -backend env -log-level error

jq -c 'keys[]' $HISTORY | while read archive_name; do
    if [ jq '[$archive_name] | has("put")' ]; then
        stellar_core_newhist $archive_name
    fi
done

exec "$@"
