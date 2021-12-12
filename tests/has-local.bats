#!/usr/bin/env bats
# shellcheck disable=SC2086

setup() {
  load helpers/test_helper
}

@test "has" {
  assert sh -c "${BATS_TEST_DESCRIPTION}"
}

@test "has -v" {
  run ${BATS_TEST_DESCRIPTION}
  [ "$status" -eq 0 ]
  assert_output "$(command -v sudo)"
}

@test "has sudo" {
  assert ${BATS_TEST_DESCRIPTION}
}

@test "has -v sudo" {
  run ${BATS_TEST_DESCRIPTION}
  assert_success
  assert_output "$(command -v sudo)"
}

@test "has -p sudo" {
  run ${BATS_TEST_DESCRIPTION}
  assert_success
}

@test "has -vp sudo" {
  run ${BATS_TEST_DESCRIPTION}
  assert_success
  assert_output "$(command -v sudo)"
}
