FROM alpine:latest
LABEL maintainer="Jason Wilder <mail@jasonwilder.com>"

ARG ARCH=arm64
ENV VERSION 0.7.5
ENV DOWNLOAD_URL https://github.com/deznorth/docker-gen/releases/download/$VERSION/docker-gen-alpine-linux-$ARCH-$VERSION.tar.gz
ENV DOCKER_HOST unix:///tmp/docker.sock

RUN apk --update --no-cache add curl gzip tar

RUN curl -fsSL $DOWNLOAD_URL | tar -zxv -C /usr/local/bin

ENTRYPOINT ["/usr/local/bin/docker-gen"]
