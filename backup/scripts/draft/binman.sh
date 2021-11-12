#!/usr/bin/env bash
#
# Creates bash_completion, bin and man files for project with src/{bash_completion.d,bin,info,man} directories.
# Source bats libraries when sourced.


# subdirectories names (keys: bin, completion, info and man)
declare -A DIRS=(["bin"]="" ["completion"]="" ["man"]="" )
# project paths/names associated array (persists if sourced), keys: bin, completion, man, name and root
declare -Ax PROJECT=(["bin"]="" ["completion"]="" ["man"]="" ["name"]="" ["root"]="")
# script name withouth extension
SCRIPT="$(basename "${BASH_SOURCE[0]}" .sh)"
# new version for man page
export VERSION=""

function main() {
  local  root

  while ((${#})); do
    case "${1}" in
     -h|--help)
        $( which man ) -p cat "${SCRIPT}" 2>/dev/null
        return
        ;;
    --new-version)
      if [[ ! "${2}" =~ ^-- ]] && [[ "${2}" != "-h" ]]; then
        if test -d "${2}"; then
          echo "${SCRIPT}: ${2@Q}: invalid --new-version, a directory was given"
          exit 1
        fi
        shift
        VERSION="${1}"
      fi
      ;;
    -*)
      echo "${SCRIPT}: ${1}: invalid option"
      exit 1
      ;;
    *)
      cd "${1}" || { echo "${SCRIPT}: ${1@Q}: No such directory"; return 1; }
      root="$(pwd)"
      ;;
    esac
    shift
  done
  sourced
  DEST="${root}/${DEST}"
  SRC="${root}/${SRC}"
  if test -d "${SRC}"; then
    PROJECT=(["bin"]="" ["completion"]="" ["man"]=""  ["info"]="" ["name"]="$(basename "${root}")" ["root"]="${root}")
  else
    clean
    return
  fi

}

main "${@}"
