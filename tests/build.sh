#!/bin/bash
set -e

build() {
  local image tag
  while read -r image tag; do
    echo $image $tag
    docker build --build-arg image="${image}" --target build --tag "${tag}" "${top}"
  done < <("${top}"/tools/images.sh tests)
}

remove() {
  local image
  while read -r image; do
    docker image rm "${image}"
  done < <("${top}"/tools/images.sh tests-images)
}

scan() {
  local image
  (
    cd "${top}"
    while read -r image; do
      docker scan --accept-license --exclude-base --file Dockerfile "${image}"
    done < <("${top}"/tools/images.sh tests-images)
  )
}

#######################################
# Build test images
#######################################
main() {
  top="$(git top)"
  [ -x "${0}" ] || chmod +x "${0}"
  case "${1}" in build|remove|scan) ${1} ;; esac
}

main "${@}"
