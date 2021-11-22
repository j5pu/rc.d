#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

# shellcheck disable=SC2016
test-shells() {
  bash -c '. profile.d/00.sh && [ -n "${IS_BASH}" ] && [ "${IS_BASH}" = "true" ]'
  sh -c '. profile.d/00.sh && [ -n "${IS_BASH}" ] && [ "${IS_BASH}" = "false" ]'
  for i in dash ksh zsh; do ${i} -c '. profile.d/00.sh && [ -z "${IS_BASH}" ]'; done
}

test-shells
