FROM mirror.jd.com/project-9n/alpine-base:latest
MAINTAINER Zhiyong Zhao <zhaozhiyong@jd.com>

RUN apk add --update python3 && \
    rm -rf /var/cache/apk/*

ADD pip.conf /etc/

RUN pip3 install --upgrade pip
