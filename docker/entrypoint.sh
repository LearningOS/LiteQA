#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
mkdir -p /home/app/tmp/pids
rm -f /home/app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
