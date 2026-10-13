#!/bin/sh

set -eu

# prevent overlapping runs
exec 9>/var/lock/mm_backup.lock
flock -n 9 || { echo "backup already running, skipping"; exit 0; }

# dump to a unique file to avoid collisions
tmp=$(mktemp ./dump.XXXXXX)
trap 'rm -f "$tmp"' EXIT

# pull db dump
pg_dump ${PG_DUMP_ARGS:-} ${DB_URL} > "$tmp"

# upload dump to s3
key="$FILE_PREFIX$(date +"%Y-%m-%d-%H:%M:%S").sql"
if [ -z "${ENDPOINT_URL:-}" ]; then
  aws s3 cp "$tmp" "s3://${BUCKET_NAME}/$key"
else
  aws --endpoint-url "${ENDPOINT_URL}" s3 cp "$tmp" "s3://${BUCKET_NAME}/$key"
fi
