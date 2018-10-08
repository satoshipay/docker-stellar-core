#!/usr/bin/env bash

set -ue

function gcloud_init() {
  local KEY_FILE="/tmp/gcloud-service-account-key.json"
  if [ -z "${GCLOUD_SERVICE_ACCOUNT_KEY:-}" ]; then
    echo "GCLOUD_SERVICE_ACCOUNT_KEY missing, skipping gcloud initialization..."
    return 0
  fi

  echo "Initializing gcloud service account..."
  echo "$GCLOUD_SERVICE_ACCOUNT_KEY" > $KEY_FILE
  gcloud auth activate-service-account --key-file $KEY_FILE
  echo "Initialized gcloud service account."
}

gcloud_init

exec /entry.sh "$@"
