#!/usr/bin/env bash

set -ue

confd -onetime -backend env -log-level error

exec "$@"
