#!/usr/bin/env bash

test="1"

for arg; do
  case "${arg}" in
    --clone) unset test ;;
  esac
done
if [ "${1}" = "test" ]; then
docker build --target alpine --tag j5pu/alpine --file tests/Dockerfile
