#!/usr/bin/env bats

setup() {
  load test_helper
  setup_rc_d_test
  desc="rc_d_test script in sh for the repository README.adoc and no main() function"
}

@test "rc_d_test " {
  assert rc_d_test
  run rc_d_test
  assert_output - <<STDIN
DEBUG: ${DEBUG:-}
DRYRUN: ${DRYRUN:-}
QUIET: ${QUIET:-}
VERBOSE: ${VERBOSE:-}
WARNING: ${WARNING:-}
args: ${args:-}
STDIN
}

@test "rc_d_test --debug --dryrun --quiet --verbose --warning " {
  run rc_d_test --debug --dryrun --quiet --verbose --warning
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

@test "rc_d_test --debug --dryrun --other-option --quiet --verbose --warning opt " {
  run rc_d_test --debug --dryrun --quiet --other-option --verbose --warning opt
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

@test "rc_d_test --desc " {
  run rc_d_test --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "rc_d_test --verbose --desc opt " {
  run rc_d_test --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "rc_d_test --help: Error " {
  run rc_d_test --help
  assert_failure
}

@test "rc_d_test --version: Error " {
  run rc_d_test --help
  assert_failure
}

@test "rc_d_test --man-repo: Error " {
  run rc_d_test --help
  assert_failure
}
