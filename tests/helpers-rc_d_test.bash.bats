#!/usr/bin/env bats

setup() {
  load helpers/test_helper
  setup_rc_d_test
  desc="rc_d_test.bash is a test script in bash with main() function"
}

@test "rc_d_test.bash " {
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

@test "rc_d_test.bash --debug --dryrun --quiet --verbose --warning " {
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

@test "rc_d_test.bash --debug --dryrun --other-option --quiet --verbose --warning opt " {
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

@test "rc_d_test.bash --debug --dryrun -h --help --manrepo --version --other-option ... opt " {
  run rc_d_test.bash --debug --dryrun --desc -h --help --manrepo --version --quiet --other-option \
    --verbose --warning opt
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: 1
DRYRUN: 1
QUIET: 1
VERBOSE: 1
WARNING: 1
args: --desc -h --help --manrepo --version --other-option opt
--desc
Another help: -h
Another help: --help
--manrepo
--version
--other-option
opt
STDIN
}

@test "rc_d_test.bash --desc " {
  run rc_d_test.bash --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${desc}
STDIN
}

@test "rc_d_test.bash --verbose --desc opt " {
  run rc_d_test.bash --verbose --desc opt
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: ${a:-}
DRYRUN: ${a:-}
QUIET: ${a:-}
VERBOSE: 1
WARNING: ${a:-}
args: --desc opt
--desc
opt
STDIN
}

@test "rc_d_test.bash -h: Error " {
  run rc_d_test.bash -h
  assert_failure
}

@test "rc_d_test.bash --help: Error " {
  run rc_d_test.bash --help
  assert_failure
}

@test "rc_d_test.bash --version: Error " {
  run rc_d_test.bash --help
  assert_failure
}

@test "rc_d_test.bash --manrepo: Error " {
  run rc_d_test.bash --help
  assert_failure
}

@test "rc_d_test.bash --debug --dryrun --quiet --verbose --warning -- bash version " {
  run rc_d_test.bash --debug --dryrun --quiet --verbose --warning -- bash version
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: 1
DRYRUN: 1
QUIET: 1
VERBOSE: 1
WARNING: 1
args: -- bash version
--
bash
version
STDIN
}


@test "rc_d_test.bash -parse --help opt " {
  run rc_d_test.bash -parse --help opt
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
DEBUG: ${a:-}
DRYRUN: ${a:-}
QUIET: ${a:-}
VERBOSE: ${a:-}
WARNING: ${a:-}
args: -parse --help opt
-parse
Another help: --help
opt
STDIN
}

@test "rc_d_test.bash -parse --desc " {
  run rc_d_test.bash -parse --desc
  [ "$status" -eq 0 ]
  assert_output - <<STDIN
${PARSE_DESC}
STDIN
}

