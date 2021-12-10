ARG repo=alpine
ARG tag=latest
ARG image="${repo}:${tag}"

ARG BASH_ENV=${BASH_ENV:-/etc/profile}
ARG ENV=${ENV:-$BASH_ENV}

FROM ${image}
ARG BASH_ENV
ENV BASH_ENV $BASH_ENV
ARG ENV
ENV ENV $ENV
SHELL ["/bin/sh", "-l", "-c"]

ADD https://github.com/j5pu/rc.d/tarball/main /tmp
RUN mkdir /tmp/rc.d && tar -xf /tmp/main -C /tmp/rc.d && /tmp/rc.d/install && rm -rf /tmp/main /tmp/rc.d
