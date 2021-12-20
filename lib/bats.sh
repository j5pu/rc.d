#!/bin/sh

# Add & updates bats submodules, sources libraries and set helper variables.
#
set -eux

# <html><h2>Bats Test Filename Prefix (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TEST_PREFIX</code></strong> prefix of BATS_TEST_DIRNAME basename.</p>
# </html>
# <html><h2>Bats Test Filename Prefix (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TEST_FILENAME_PREFIX</code></strong> prefix of BATS_TEST_FILENAME basename.</p>
# </html>
BATS_TEST_FILENAME_PREFIX="$(basename "${BATS_TEST_FILENAME:-}" .bats)"; export BATS_TEST_FILENAME_PREFIX

bats_add() {
  cd "${RC_PREFIX}"
  if git submodule --quiet add --name "$1" https://github.com/bats-core/"$1" share/"$1" 1>/dev/null; then
    directory="$(bats_path "$1")"
    [ "${directory-}" ] && git submodule --quiet sync --recursive "${directory}"
  fi
}

bats_load() {
  if [ ! "${directory-}" ] || ! directory="$(bats_path "$1")"; then
    bats_add "$1"
  fi
  [ "${directory-}" ] && [ "${BASH_VERSION-}" ] && . "${directory}/load.bash"
}

bats_path() { git -C "${RC_PREFIX}" config --file .gitmodules "submodule.${1}.path" 2>/dev/null; }

bats_update() {
  if [ ! "${directory-}" ] || ! directory="$(bats_path "$1")"; then
    bats_add "$1"
  fi
  [ "${directory-}" ] && git submodule --quiet update --init "${directory}"
}

bats_main() {
  if ! command -v assert_success > /dev/null; then
    for submodule in bats-asserts bats-file; do
      if [ "${RC_PROFILE-0}" -eq 1 ]; then
        bats_update "${submodule}"
      fi
      bats_load "${submodule}"
    done
  fi
  unset directory submodule
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
