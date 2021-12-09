#!/usr/bin/env bats

load lib/test_helper

setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
  desc="rc_d_test_main is a test script in sh with main() function"
}

@test "${BATS_HEADER} rc_d_test_main" {
  assert rc_d_test_main
  run rc_d_test_main
  assert_output - <<STDIN
DEBUG: ${DEBUG:-}
DRYRUN: ${DRYRUN:-}
QUIET: ${QUIET:-}
VERBOSE: ${VERBOSE:-}
WARNING: ${WARNING:-}
args: ${args:-}
STDIN
}

@test "${BATS_HEADER} rc_d_test_main --debug --dryrun --quiet --verbose --warning" {
  run rc_d_test_main --debug --dryrun --quiet --verbose --warning
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: 1
DRYRUN: 1
QUIET: 1
VERBOSE: 1
WARNING: 1
args: ${args:-}
STDIN
}

@test "${BATS_HEADER} rc_d_test_main --debug --dryrun --other-option --quiet --verbose --warning opt" {
  run rc_d_test_main --debug --dryrun --quiet --other-option --verbose --warning opt
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: 1
DRYRUN: 1
QUIET: 1
VERBOSE: 1
WARNING: 1
args: --other-option opt
--other-option
opt
STDIN
}

@test "${BATS_HEADER} rc_d_test_main --desc" {
  run rc_d_test_main --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "${BATS_HEADER} rc_d_test_main --verbose --desc opt" {
  run rc_d_test_main --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "${BATS_HEADER} rc_d_test_main --help: Error" {
  run rc_d_test_main --help
  assert_failure
}

@test "${BATS_HEADER} rc_d_test_main --version: Error" {
  run rc_d_test_main --help
  assert_failure
}

@test "${BATS_HEADER} rc_d_test_main --man-repo: Error" {
  run rc_d_test_main --help
  assert_failure
}
