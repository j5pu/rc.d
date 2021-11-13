ARG args
ARG cero
ARG e
ARG ls
ARG ls_build
ARG DOCKER_REPO
ARG DOCKERFILE_PATH
ARG base=${base:-alpine}
ARG tag=${tag:-latest}
ARG image=${base}:${tag}

ARG BASH_ENV=${BASH_ENV:-/etc/profile}
ARG ENV=${ENV:-$BASH_ENV}

FROM $image

ARG args
ARG cero
ARG e
ARG ls
ARG ls_build
ARG DOCKER_REPO
ARG DOCKERFILE_PATH

ENV ls $ls
ENV ls_build $ls_build
ENV args $args
ENV cero $cero
ENV e $e
ENV DOCKER_REPO $DOCKER_REPO
ENV DOCKERFILE_PATH $DOCKERFILE_PATH

ARG BASH_ENV
ENV BASH_ENV $BASH_ENV
ARG ENV
ENV ENV $ENV
COPY profile.d /etc/profile.d

#FROM alpine:latest as base
#FROM archlinux:latest as base
#FROM bash:latest as base
#FROM bash:5.1 as base
#FROM bash:5.0 as base
#FROM bash:4.4 as base
#FROM bats/bats:latest as base
#FROM busybox:latest as base
#FROM centos:latest as base
#FROM debian:latest as base
#FROM debian:bullseye-backports as base
#FROM debian:bullseye-slim as base
#FROM fedora:latest as base
#FROM jrei/systemd-ubuntu:latest as base
#FROM kalilinux/kali-rolling:latest as base
#FROM kalilinux/kali-bleeding-edge:latest as base
#FROM nixos/nix:latest as base
#FROM python:3.9-alpine as base
#FROM python:3.9-bullseye as base
#FROM python:3.9-slim as base
#FROM python:3.10-alpine as base
#FROM python:3.10-bullseye as base
#FROM python:3.10-slim as base
#FROM richxsl/rhel7:latest as base
#FROM ubuntu:latest as base
#FROM zshusers/zsh:latest as base
