#!/usr/bin/env bash
#
# ls-recent: list files in a directory tree, most recently modified first.
#
# Usage: ls-recent [path] [-n | more]
#
#######################################
# List files in a directory tree, most recently modified first.
# Globals:
#   None
# Arguments:
#   path      path to target directory (default: .)
#   more      pager to use (default: head)
#   -n        number of lines for `head` output (default: 1)
# ######################################
function main() {
  local arg cmd lines="1" path
  for arg; do
    case "${arg}" in
      -*) lines="${arg:1}" ;;
      more) cmd="${arg}" ;;
      *) path="${arg}"
    esac
    shift
  done
  find "${path:-.}" -type f -print0 | xargs -0 gstat --format '%Y %y %A %G %U %s %N' | sort -nr | \
    awk '{ print substr($0, index($0,$2)) }' | ${cmd:-head -${lines}}
}

main "${@}"
