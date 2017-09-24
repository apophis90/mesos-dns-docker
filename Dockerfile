FROM ubuntu:latest

MAINTAINER Patrick Kleindienst

RUN apt-get update \
    && apt-get install gnupg wget bash -y

# Setup environment for convenience.
ENV MESOS_DNS_VERSION=0.6.0
ENV ARCH=amd64
ENV OS=linux
ENV MESOS_DNS_PORT=53
ENV MESOSPHERE_PUB_KEY=111A0371BD292F47

WORKDIR /mesos-dns

# Fetch Mesos-DNS binary and signature file.
RUN wget https://github.com/mesosphere/mesos-dns/releases/download/v$MESOS_DNS_VERSION/mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH \
    && wget https://github.com/mesosphere/mesos-dns/releases/download/v$MESOS_DNS_VERSION/mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH.asc

# Import Mesosphere Public Key and verify the binary's signature.
RUN gpg --keyserver pgpkeys.mit.edu --recv-key $MESOSPHERE_PUB_KEY \
    && gpg --verify mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH.asc mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH

# Clean up and make Mesos-DNS binary executable by owner.
RUN rm mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH.asc \
    && mv mesos-dns-v$MESOS_DNS_VERSION-$OS-$ARCH mesos-dns \
    && chmod 700 mesos-dns

EXPOSE $MESOS_DNS_PORT

ENTRYPOINT ./mesos-dns -config=./config.json
