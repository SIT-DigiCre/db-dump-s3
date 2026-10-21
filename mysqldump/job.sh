#!/bin/sh

set -eu

# prevent overlapping runs
exec 9>/var/lock/mysql_backup.lock
flock -n 9 || { echo "backup already running, skipping"; exit 0; }

# dump to a unique file to avoid collisions
tmp=$(mktemp /tmp/mysql_dump.XXXXXX)
trap 'rm -f "$tmp"' EXIT

# pull db dump
mysqldump ${MYSQLDUMP_ARGS:-} -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$tmp"

# upload dump to s3
key="${FILE_PREFIX:-}$(date +"%Y-%m-%d-%H:%M:%S").sql"
if [ -z "${ENDPOINT_URL:-}" ]; then
  aws s3 cp "$tmp" "s3://${BUCKET_NAME}/$key"
else
  aws --endpoint-url "${ENDPOINT_URL}" s3 cp "$tmp" "s3://${BUCKET_NAME}/$key"
fi
