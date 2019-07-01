#!/usr/bin/env bash

set -ue

function stellar_core_init_db() {
  if [ -z ${INITIALIZE_DB:-} ] || [ "${INITIALIZE_DB}" != "true" ]; then
    echo "Not initializing DB (set INITIALIZE_DB=true if you want to initialize it)."
    return 0
  fi

  local DB_INITIALIZED="/data/.db-initialized"

  if [ -f $DB_INITIALIZED ]; then
    echo "Core db has already been initialized."
    return 0
  fi

  echo "Initializing core db..."

  stellar-core new-db --conf /stellar-core.cfg

  echo "Finished initializing core db"

  touch $DB_INITIALIZED
}

function stellar_core_init_history_archives() {
  if [ -z ${INITIALIZE_HISTORY_ARCHIVES:-} ] || [ "${INITIALIZE_HISTORY_ARCHIVES}" != "true" ]; then
    echo "Not initializing history archives (set INITIALIZE_HISTORY_ARCHIVES=true if you want to initialize them)."
    return 0
  fi

  for HISTORY_ARCHIVE in $(echo $HISTORY | jq -r 'to_entries[] | select (.value.put?) | .key'); do
    local HISTORY_ARCHIVE_INITIALIZED="/data/.history-archive-${HISTORY_ARCHIVE}-initialized"

    if [ -f $HISTORY_ARCHIVE_INITIALIZED ]; then
      echo "History archive ${HISTORY_ARCHIVE} has already been initialized."
      continue
    fi

    echo "Initializing history archive ${HISTORY_ARCHIVE}..."

    stellar-core new-hist $HISTORY_ARCHIVE --conf /stellar-core.cfg

    echo "Finished initializing history archive ${HISTORY_ARCHIVE}."

    touch $HISTORY_ARCHIVE_INITIALIZED
  done
}

confd -onetime -backend env -log-level error

stellar_core_init_db
stellar_core_init_history_archives

exec "$@"
