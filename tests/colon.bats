#!/usr/bin/env bats
# shellcheck disable=SC2001

setup() {
  load helpers/test_helper
}

assertoutput() {
  os="${1:-macOS}"
  description "${os}"
  if [ "${os}" = 'macOS' ]; then
    run sh -c "${cmd}"
  else
    run container "${os}" "sh -c '${cmd}'"
  fi

  if [ "${ERROR-}" ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${CALLBACK-}" ]; then
    $(echo "${BATS_TEST_DESCRIPTION}" | sed 's/ /::/g') "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED}"
  fi
}

cmd() {
  assertoutput
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertoutput "${i}"; done
}


@test 'colon' { EXPECTED='/'; cmd='cd / && real'; cmd; }

