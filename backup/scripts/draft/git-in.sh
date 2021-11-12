#!/usr/bin/env bash

function main() {
  git ls-files --cached --error-unmatch --full-name --others "$(realpath "${1}")"
}

main "${@}"
