#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2153

images=$(cat <<EOF
# alpine:edge (20210804)
# alpine:latest (3, 3.14)
alpine:latest
# alpine:3.13
# alpine:3.12

# archlinux:base-devel
archlinux:latest

# bash:devel
bash:latest
# bash:5.1
# bash:5.0
# bash:4.4

bats/bats:latest

busybox:latest

# centos:latest (8)
centos:latest
# centos:7

# debian:bookworm
# debian:bookworm-backports
# debian:bookworm-slim
# debian:latest (bullseye)
debian:latest
# debian:bullseye-backports
# debian:bullseye-slim
# debian:buster
# debian:buster-backports
# debian:buster-slim


# fedora:36
# fedora:latest (35)
fedora:latest
# fedora:34

# jrei/systemd-ubuntu:latest (20.04 - focal)
jrei/systemd-ubuntu:latest
# jrei/systemd-ubuntu:focal
# jrei/systemd-ubuntu:bionic

# kalilinux/kali-rolling:latest (armhf, arm64, amd64)
# apt -y install <package|kali-linux-headless|kali-linux-large>
kalilinux/kali-rolling:latest
kalilinux/kali-bleeding-edge:latest

nixos/nix:latest

python/3.9-alpine
python/3.9-bullseye
python/3.9-slim
python/3.10-alpine
python/3.10-bullseye
python/3.10-slim

richxsl/rhel7:latest

# 22.04, jammy, devel
# ubuntu:22.04
# 21.10, impish, rolling
# ubuntu:21.10
# 21.04, hirsute
# ubuntu:21.04
# ubuntu:latest (20.04, focal)
ubuntu:latest
# 16.04, xenial
# ubuntu:16.04
# 18.04, bionic
# ubuntu:18.04

zshusers/zsh:latest
EOF
)
: "${GIT:=j5pu}"

top="$(git top)"

cmp() {
  command cmp -s "${tmp}" "${file}" || { cp "${tmp}" "${file}"; echo "changed: ${file}"; }
}

hooks() {
  local filename
  for file in "${top}"/hooks/*; do
    [ -x "${file}" ] || chmod +x "${file}"
    filename="$(basename "${file}")"
    tmp="/tmp/${filename}"
    [ -w "${file}" ] && {
      awk '/images=$(cat <<EOF/ { exit } { print }'
      echo 'images=$(cat <<EOF'
      images
      printf '%s\n' 'EOF' ')'
    } > "${tmp}"
    cmp
  done
}

images() {
  echo "${images}" | sed 's|python/|python/python:|g' | awk -v "s= ${GIT}/" '!/^#/ && NF>0 { print $1 s $1 }' | \
    sed -e "s|${GIT}/.*/|${GIT}/|g"
}

tags() {
  images | awk '{ print $2 }'
}

tags-sh() {
  local filename tags
  filename="tags.sh"
  file="${top}/profile.d/${filename}"
  tmp="/tmp/${filename}"
  tags="$(tags)"
  {
    echo 'TAGS=$(cat <<EOF'
    echo "${tags}"
    printf '%s\n' 'EOF' ')' 'export TAGS'
  } > "${tmp}"
  cmp && source "${tmp}" && { [ "$(tags)" == "${TAGS}" ] || { echo -e "tags:\n${tags}\nTAGS:\n${TAGS}"; exit 1; }; }
}

[ -x "${0}" ] || chmod +x "${0}"
case "${1}" in hooks|images|tags|tags-sh) ${1} ;; esac
