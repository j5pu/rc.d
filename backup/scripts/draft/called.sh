#!/usr/bin/env bash
#
# Creates bash_completion, bin, info and man files for project with src/{bash_completion.d,bin,info,man} directories.
# Source bats libraries when sourced.


called() {
  local absolute_dir filename relative_dir relative_path
  rv="$(caller "${1:-0}")"
  declare -Ax CALLED=(['line']="$(echo "${rv}" | awk '{print $1}')" ['func']="$(echo "${rv}" | awk '{print $2}')")
  relative_path="$(echo "${rv}" | awk '{ print substr($0, index($0,$3)) }')"
  relative_dir="$(dirname "${relative_path}")"
  absolute_dir="$(cd "${relative_dir}" && pwd || { echo "${FUNCNAME[0]}: ${relative_dir}: No such directory"; })"
  filename="$(basename "${relative_path}")"
  CALLED['']=
  caller "${1:-0}"

}

export -f called
