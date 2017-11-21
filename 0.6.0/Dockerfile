FROM debian:stretch-slim as builder

RUN apt-get update && apt-get install -y \
    gnupg \
    wget

ARG MESOS_DNS_VERSION=0.6.0
ARG ARCH=amd64
ARG OS=linux
ARG MESOSPHERE_PUB_KEY=111A0371BD292F47

RUN wget https://github.com/mesosphere/mesos-dns/releases/download/v$MESOS_DNS_VERSION/mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH && \
    wget https://github.com/mesosphere/mesos-dns/releases/download/v$MESOS_DNS_VERSION/mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH.asc && \
    gpg --keyserver pgpkeys.mit.edu --recv-key $MESOSPHERE_PUB_KEY && \
    gpg --verify mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH.asc mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH && \
    mv mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH mesos-dns


FROM debian:stretch-slim

MAINTAINER Patrick Kleindienst

ARG MESOS_DNS_PORT=53

COPY --from=builder /mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH .

RUN chmod 700 mesos-dns

EXPOSE $MESOS_DNS_PORT

ENTRYPOINT ./mesos-dns -config=./config.json
