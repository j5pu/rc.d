#!/usr/bin/env bats

setup() {
    load helpers/test_helper
}

@test "env" {
  assert [ "${TOP-}" ]
  assert test "${TOP:-}"
  assert test "${TOP_NAME:-}"
  assert test "${BATS_TOP:-}"
  assert test "${BATS_TOP_NAME:-}"
  assert test "${TESTS:-}"
  assert test "${RC_D_TEST_NAME:-}"
  assert test "${RC_D_TEST:-}"
  assert sh -c "echo ${PATH} | grep -q ${RC_D_TEST}"
  assert sh -c "echo ${MANPATH} | grep -q ${RC_D_TEST}"
  assert test "${INPUT:-}"
}
