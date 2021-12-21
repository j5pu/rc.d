#!/bin/sh
# shellcheck disable=SC1090

# Add & updates bats submodules, sources libraries and set helper variables.
#
set -eu

# <html><h2>Bats Test Filename Prefix (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TEST_PREFIX</code></strong> prefix of BATS_TEST_DIRNAME basename.</p>
# </html>
# <html><h2>Bats Test Filename Prefix (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TEST_FILENAME_PREFIX</code></strong> prefix of BATS_TEST_FILENAME basename.</p>
# </html>
BATS_TEST_FILENAME_PREFIX="$(basename "${BATS_TEST_FILENAME:-}" .bats)"; export BATS_TEST_FILENAME_PREFIX

# <html><h2>Git Top Path (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TOP</code></strong> contains the git top directory when sourced from a git dir.</p>
# </html>
BATS_TOP="$(git top)"; export BATS_TOP

# <html><h2>Git Top Basename (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TOP_NAME</code></strong> basename of git top directory when sourced from a git dir.</p>
# </html>
BATS_TOP_NAME="$(git basename)"; export BATS_TOP_NAME

bats_add() {
  if command -p git -C "${RC_PREFIX}" submodule --quiet add --name "$1" \
    https://github.com/bats-core/"$1" share/"$1" 1>/dev/null; then
    bats_directory="$(bats_path "$1")"
    [ "${bats_directory-}" ] && command -p git -C "${RC_PREFIX}" submodule --quiet sync --recursive "${bats_directory}"
    echo "${bats_directory}"
    unset bats_directory
  fi
}

bats_load() {
 [ "${1-}" ] && { [ ! "${BASH_VERSION-}" ] || . "${RC_PREFIX}/${1}/load.bash"; }; }

bats_path() { command -p git -C "${RC_PREFIX}" config --file .gitmodules "submodule.${1}.path" 2>/dev/null; }

bats_update() { [ "${1-}" ] && command -p git -C "${RC_PREFIX}" submodule --quiet update --init "${1}"; }

bats_main() {
  if ! command -v assert_success >/dev/null; then
    for submodule in bats-assert bats-file; do
      if ! bats_directory="$(bats_path "${submodule}")"; then
        bats_directory="$(bats_add "${submodule}")"
      fi
      if [ "${RC_PROFILE-0}" -eq 0 ]; then
        bats_update "${bats_directory}"
      fi
        bats_load "${bats_directory}"
    done
    [ ! "${BASH_VERSION-}" ] || command -v assert_success >/dev/null
  fi
  unset bats_directory submodule
}

bats_main

unset -f bats_add bats_load bats_main bats_path bats_update

####################################### Executed: force & parse
#
if echo "$0" | grep -q 'bats.sh$'; then
  if test "$#" -ne 0 && test "${1-}" = '--parsed' && shift; then
    case "$1" in
      --force) shift; profile --force
    esac
  else
#    . helpers.lib
#    PARSE="$0" parse "$@"
    true
  fi
fi
