#!/usr/bin/env bats

setup() {
    . dev.lib
    env="${BATS_TEST_DIRNAME}/.env"
}

@test "bats libs functions declared " {
   for func in assert_equal assert_file_exist batslib_err; do
    assert declare -pF "${func}"
  done
}

@test ".env exists " {
  assert_exist "${env}"
}

@test ".envrc" {
  for i in
  assert [ "${PROJECT_DIR-}" ]
  assert test "${PROJECT_DIR:-}"
  echo PROJECT_DIR: "${PROJECT_DIR:-}" >&3

  assert test "${PROJECT_NAME-}"
  echo PROJECT_NAME: "${PROJECT_NAME:-}" >&3

  if [ "${BATS_LOCAL:-}" -eq 1 ]; then
    run $BATS_DOCKER
    assert_failure
  else
    assert $BATS_DOCKER
  fi
  echo BATS_LOCAL: "${BATS_LOCAL-}" >&3
  echo BATS_DOCKER: "${BATS_DOCKER:-}" >&3

  assert test "${BATS_JOBS-}"
  echo BATS_JOBS: "${BATS_JOBS:-}" >&3

  assert test "${BATS_TOP-}"
  echo BATS_TOP: "${BATS_TOP:-}" >&3

  assert test "${BATS_TOP_NAME-}"
  echo BATS_TOP_NAME: "${BATS_TOP_NAME:-}" >&3

  assert test "${TESTS-}"
  echo TESTS: "${TESTS:-}" >&3

  assert test "${FIXTURES-}"
  echo FIXTURES: "${FIXTURES:-}" >&3

  assert test "${RC_D_TEST_NAME-}"
  echo RC_D_TEST_NAME: "${RC_D_TEST_NAME:-}" >&3

  assert test "${RC_D_TEST-}"
  echo RC_D_TEST: "${RC_D_TEST:-}" >&3

  assert test "${RC_D_TEST_SHARE-}"
  echo RC_D_TEST_SHARE: "${RC_D_TEST_SHARE:-}" >&3

  assert sh -c "echo ${PATH} | grep -q ${RC_D_TEST}"
  echo PATH: "${PATH:-}" >&3

  assert sh -c "echo ${MANPATH} | grep -q ${RC_D_TEST}"
  echo MANPATH: "${MANPATH:-}" >&3

  assert test "${INPUT-}"
  echo INPUT: "${INPUT:-}" >&3
}
