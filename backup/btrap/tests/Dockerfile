# syntax=docker/dockerfile:1
#WORKDIR=../
#ARG IMAGE
#ENV IMAGE=${IMAGE:-alpine}
ARG LOCAL
ENV LOCAL=${LOCAL:-1}
#ARG TAG
#ENV TAG=${TAG:-latest}
#ARG PYOS
#ENV PYOS=${PYOS:-alpine}
#ARG PYVERS
#ENV PYVERS=${PYVERS:-3.9}
#ENV PYTAG=${PYVERS}-${PYOS}
ONBUILD RUN pwd
FROM alpine:latest AS alpine
FROM bats:latest AS bats
FROM busybox:latest AS busybox
FROM debian:latest AS debian
FROM kalilinux:kali-rolling AS kali
FROM debian:latest AS debian
FROM nix:latest AS nix
FROM python:3.10-bullseye AS python310-bullseye
FROM python:3.10-slim AS python310-slim
FROM python:3.10-alpine AS python10
FROM python:3.9-bullseye AS python39-bullseye
FROM python:3.9-slim AS python39-slim
FROM python:3.9-alpine AS python39
FROM ubuntu:latest AS ubuntu

# docker build --build-arg IMAGE=debian LOCAL=0 .

# Build
# export DOCKER_BUILDKIT=1 or daemon.json: { "features": { "buildkit": true } }
# docker build --ssh default=~/.ssh/id_rsa .

#RUN apt update -qq
#RUN apt install -y openssh-client git

# Download public key for github.com
#RUN --mount=type=ssh mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone private repository
#RUN --mount=type=ssh git clone git@github.com:j5pux/config.git config
