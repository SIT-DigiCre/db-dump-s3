#!/bin/sh

# pull db dump
pg_dump ${PG_DUMP_ARGS:-} ${DB_URL} > dump.sql;

# upload dump to s3
if [ -z ${ENDPOINT_URL} ]; then
  aws s3 cp ./dump.sql s3://${BUCKET_NAME}/"$FILE_PREFIX$(date +"%Y-%m-%d-%H:%M:%S")".sql && rm ./dump.sql
else
  aws --endpoint-url ${ENDPOINT_URL} s3 cp ./dump.sql s3://${BUCKET_NAME}/"$FILE_PREFIX$(date +"%Y-%m-%d-%H:%M:%S")".sql && rm ./dump.sql
fi
