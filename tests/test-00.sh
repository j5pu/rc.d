#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

# shellcheck disable=SC2016
test-shells() {
  bash -c '. profile && [ -n "${BASH_SH}" ] && [ -n "${SH}" ]'
  sh -c '. profile && [ -n "${SH}" ]'
  for i in dash ksh zsh; do ${i} -c '. profile && [ -z "${BASH_SH}" ]'; done
}

test-shells
