#!/usr/bin/env bash
#shellcheck disable=SC1090
#
# Creates bash_completion, bin, info and man files for project with src/{bash_completion.d,bin,info,man} directories.
# Source bats libraries when sourced.

#######################################
# Vars declaration and definitions
# author username
export AUTHOR
# a destination file was changed
export CHANGED=false
# destination directory full path
export DEST="generated"
# destination directory with subdirectory full path
export DEST_DIR
# destination file full path
export DEST_FILE
# subdirectories names associated array, keys: bin, completion, info and man
declare -Ax DIRNAMES=(["bin"]="" ["completion"]="" ["man"]=""  ["info"]="")
# source filename
export FILENAME
# INFOPATH with destination "info" directory added (persists if sourced)
export INFOPATH
# MANPATH with destination "man" directory added (persists if sourced)
export MANPATH
# filename without extension
export NAME
# PATH with destination "bin" directory added (persists if sourced)
export PATH
# project paths/names associated array (persists if sourced), keys: bin, completion, info, man, name and root
declare -Ax PROJECT=(["bin"]="" ["completion"]="" ["man"]=""  ["info"]="" ["name"]="" ["root"]="")
# script name withouth extension
export SCRIPT
SCRIPT="$(basename "${BASH_SOURCE[0]}" .sh)"
# script has been sourced
export SOURCED=false
# sources directory full path
export SRC="src"
# source directory with subdirectory full path
export SRC_DIR
# source file full path
export SRC_FILE
# subdirectories names
declare -Ax SUBDIRS
# new version for man and info page
export VERSION=""


#######################################
# Removes extension (.sh and .py) from a given directory under src and copy if source changed.
# Source completions or adds destination directory to PATH when script is sourced.
# Globals:
#   CHANGED
#   DEST
#   DEST_FILE
#   NAME
#   PATH
#   PROJECT
#   SOURCED
#   SRC
#   SRC_FILE
# Arguments:
#   1                 directory name to process (default: function name)
# ######################################
function bin() {
  SRC_DIR="${SRC}/${1:-${FUNCNAME[0]}}"
  DEST_DIR="${DEST}/${1:-${FUNCNAME[0]}}"

  test -d "${SRC_DIR}" || return
  test -d "${DEST_DIR}" || { CHANGED=true; mkdir "${DEST_DIR}"; }

  while read -r SRC_FILE; do
    test -x "${SRC_FILE}" || { CHANGED=true; chmod +x "${SRC_FILE}"; git add --chmod +x "${SRC_FILE}"; }
    DEST_FILE="$(echo "${DEST_DIR}/${SRC_FILE##*/}" | sed 's/.sh$//g; s/.py$//g')"
    echo "${DEST_FILE}"
    if ! test -f "${DEST_FILE}" || ! cmp -s "${SRC_FILE}" "${DEST_FILE}"; then
      cp "${SRC_FILE}" "${DEST_FILE}"
      changed
    fi
  done < <(find "${SRC_DIR}" -type f -not -name "*/.*")
  if $SOURCED; then
    if [[ "${1:-}" ]]; then
      PROJECT["completion"]="${DEST_DIR}"
      for completion in "${DEST_DIR}"/*; do
        source "${completion}" || return 1
      done
      return
    fi
    PROJECT["${FUNCNAME[0]}"]="${DEST_DIR}"
    export PATH="${DEST_DIR}:${PATH}"
  fi
}

#######################################
# Unsets globals and functions which should not persists after been sourced
# Globals:
#   AUTHOR
#   CHANGED
#   DEST
#   DEST_FILE
#   NAME
#   SCRIPT
#   SOURCED
#   SRC
#   SRC_FILE
#   VERSION
#######################################
function clean() {
  if $SOURCED; then
    unset AUTHOR CHANGED DEST DEST_FILE NAME SCRIPT SOURCED SRC SRC_FILE VERSION
    unset -f bin clean changed doctor info man sourced main
  fi
}

#######################################
# Git add, commit or delete changed file. Marks CHANGED as true.
# Globals:
#   CHANGED
#   DEST_FILE
#   SCRIPT
#######################################
function changed() {
  CHANGED=true
  git add "${DEST_FILE}"
  git commit --quiet -a -m "${SCRIPT} ${DEST_FILE}"
}

#######################################
# Create man page from src.
# Globals:
#   AUTHOR
#   NAME
#   SRC_FILE
#   VERSION
# Arguments:
#   1                 destination directory for man page
#######################################
function doctor() {
  asciidoctor -b manpage -a doctitle="${NAME^^}(1)" -a author="${AUTHOR}" -a release-version="0.1.1" \
    -a manmanual="${NAME^} Manual" -a mansource="${NAME^} ${VERSION}" -a name="${NAME}" -D "${1}" "${SRC_FILE}"
}

#######################################
# Create info page from src.
# Globals:
#   AUTHOR            author username
#   NAME              file name without extension
#   SRC_FILE          source file
#   VERSION           new version for man page
# Arguments:
#   1                 destination directory for info page
#######################################
function info() {
  :
}

#######################################
# Copy man or info page if source changed.
# Adds destination directory to MANPATH or INFOPATH when script is sourced.
# Globals:
#   CHANGED
#   DEST
#   DEST_FILE
#   INFOPATH
#   MANPATH
#   NAME
#   PROJECT
#   SOURCED
#   SRC
#   SRC_FILE
# Arguments:
#   1                 directory name to process (default: function name)
# ######################################
function man() {
  local  dest_name filename func="doctor"
  DEST_DIR="${DEST}/${1:-${FUNCNAME[0]}}"
  SRC_DIR="${SRC}/${1:-${FUNCNAME[0]}}"

  test -d "${SRC_DIR}" || return
  test -d "${DEST_DIR}" || { CHANGED=true; mkdir "${DEST_DIR}"; }
  [[ ! "${1:-}" ]] || func="info"
  AUTHOR="$(git config user.username)"

  while read -r SRC_FILE; do
    filename="${SRC_FILE##*/}"
    NAME="${filename%.*}"
    dest_name="${NAME}.1"
    DEST_FILE="${DEST_DIR}/${dest_name}"
    if ! test -f "${DEST_FILE}"; then
      ${func} "${DEST_DIR}"
      changed
    else
      ${func} "/tmp"
      if ! cmp -s "${SRC_FILE}" "/tmp/${dest_name}"; then
        cp "/tmp/${dest_name}" "${DEST_FILE}"
        changed
      fi
    fi
  done < <(find "${SRC_DIR}" -type f -not -name "*/.*")
  if $SOURCED; then
    if [[ "${1:-}" ]]; then
      PROJECT["${1}"]="${DEST_DIR}"
      INFOPATH="${DEST_DIR}:${INFOPATH}"
    fi
    PROJECT["${FUNCNAME[0]}"]="${DEST_DIR}"
    MANPATH="${DEST_DIR}:${MANPATH}"
  fi
}

#######################################
# Testing helper function when script is sourced to source bats libraries.
# Globals:
#   SOURCED
# Arguments:
#   None
# ######################################
function sourced() {
  local cache dest repo

  if (return 0 2>/dev/null); then
    SOURCED=true
    cache="${HOME}/.cache"
    mkdir -p "${cache}"
    for repo in bats-assert bats-file bats-support; do
      dest="${cache}/${repo}"
      if test -d "${dest}"; then
        git -C "${dest}" pull --quiet --force 1>/dev/null || return 1
      else
        git clone --quiet "https://github.com/bats-core/${repo}.git" "${dest}" 1>/dev/null || return 1
      fi
      source "${dest}/load.bash"
    done
    for func in assert_equal assert_file_exist batslib_err; do
      declare -pF "${func}"  1>/dev/null || return 1
    done
    return
  fi
}

#######################################
# Helper to set vars for functions with sources and destinations.
# Globals:
#   FILENAME
#   NAME
#   SRC_FILE
#######################################
function vars() {
  FILENAME="${SRC_FILE##*/}"
  NAME="${FILENAME%.*}"
}

#######################################
# Parse args.
# Globals:
#   AUTHOR
#   CHANGED
#   DEST
#   DEST_FILE
#   FILENAME
#   INFOPATH
#   MANPATH
#   NAME
#   PATH
#   PROJECT
#   SOURCED
#   SCRIPT
#   SRC
#   SRC_FILE
#   VERSION
# Arguments:
#   None
# Optional Arguments:
#   root              project root where src directory is located
#   --new-version     empty or version
# Returns:
#   1 if --new-version is not empty or has a directory.
#######################################
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

  bin
  bin "bash_completion.d"
  man
  man "info"

  # TODO: register functions in repo when push with the final list.

  clean

  if $CHANGED; then echo changed; else echo unchanged; fi
}

main "${@}"
