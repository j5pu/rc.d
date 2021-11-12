# syntax=docker/dockerfile:1-labs
ARG repo=alpine
ARG tag=latest
ARG image=${repo}:${tag}
FROM ${image} AS base

SHELL ["/bin/sh", "-l", "-c"]

ADD https://git.io/00.sh /etc/profile.d/00.sh
ONBUILD COPY --from=base /etc/profile.d/00.sh /etc/profile.d/00.sh

FROM base AS build
