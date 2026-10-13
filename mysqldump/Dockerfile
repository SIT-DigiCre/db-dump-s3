ARG MYSQL_IMAGE_TAG
FROM mysql:$MYSQL_IMAGE_TAG

RUN apt-get update \
 && apt-get install -y cron awscli

ADD job.sh ./job.sh
RUN chmod 755 ./job.sh

ADD entry.sh ./entry.sh
RUN chmod 755 ./entry.sh

CMD ["./entry.sh"]
