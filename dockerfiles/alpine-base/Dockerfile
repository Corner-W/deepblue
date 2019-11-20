FROM mirror.jd.com/linux/alpine:3.8
MAINTAINER Zhiyong Zhao <zhaozhiyong@jd.com>

COPY repositories /etc/apk/

RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    update-ca-certificates && \
    apk add --update tzdata

RUN rm -rf /var/cache/apk/*
