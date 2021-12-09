#!/usr/bin/env bats

load lib/test_helper

setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
  desc="rc_d_test.bash is a test script in bash with main() function"
}

@test "${BATS_HEADER} rc_d_test.bash" {
  assert rc_d_test.bash
  run rc_d_test.bash
  assert_output - <<STDIN
DEBUG: ${DEBUG:-}
DRYRUN: ${DRYRUN:-}
QUIET: ${QUIET:-}
VERBOSE: ${VERBOSE:-}
WARNING: ${WARNING:-}
args: ${args:-}
STDIN
}

@test "${BATS_HEADER} rc_d_test.bash --debug --dryrun --quiet --verbose --warning" {
  run rc_d_test.bash --debug --dryrun --quiet --verbose --warning
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

@test "${BATS_HEADER} rc_d_test.bash --debug --dryrun --other-option --quiet --verbose --warning opt" {
  run rc_d_test.bash --debug --dryrun --quiet --other-option --verbose --warning opt
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

@test "${BATS_HEADER} rc_d_test.bash --desc" {
  run rc_d_test.bash --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "${BATS_HEADER} rc_d_test.bash --verbose --desc opt" {
  run rc_d_test.bash --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "${BATS_HEADER} rc_d_test.bash --help: Error" {
  run rc_d_test.bash --help
  assert_failure
}

@test "${BATS_HEADER} rc_d_test.bash --version: Error" {
  run rc_d_test.bash --help
  assert_failure
}

@test "${BATS_HEADER} rc_d_test.bash --man-repo: Error" {
  run rc_d_test.bash --help
  assert_failure
}
