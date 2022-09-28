#!/bin/sh

# pull db dump
MYSQLDUMP_COMMAND="mysqldump ${MYSQLDUMP_ARGS:-} -h ${DB_HOST} -u ${DB_USER} -p'${DB_PASSWORD}' ${DB_NAME}"

# upload dump to s3
if [ -z ${ENDPOINT_URL} ]; then
  eval $MYSQLDUMP_COMMAND | aws s3 cp - s3://${BUCKET_NAME}/"$FILE_PREFIX$(date +"%Y-%m-%d-%H:%M:%S")".sql
else
  eval $MYSQLDUMP_COMMAND | aws --endpoint-url ${ENDPOINT_URL} s3 cp - s3://${BUCKET_NAME}/"$FILE_PREFIX$(date +"%Y-%m-%d-%H:%M:%S")".sql
fi
