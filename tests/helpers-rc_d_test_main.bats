#!/usr/bin/env bats

setup() {
  load helpers/test_helper
  setup_rc_d_test
}

@test "rc_d_test_main " {
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

@test "rc_d_test_main --debug --dryrun --quiet --verbose --warning " {
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

@test "rc_d_test_main --debug --dryrun --other-option --quiet --verbose --warning opt " {
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

@test "rc_d_test_main --debug --dryrun -h --help --manrepo --version --other-option ... opt " {
  run rc_d_test_main --debug --dryrun --desc -h --help --manrepo --version --quiet --other-option --verbose \
    --warning opt
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

@test "rc_d_test_main --desc " {
  run rc_d_test_main --desc
  [ "$status" -eq 0 ]
  assert_output "$(getdesc rc_d_test_main)"
}

@test "rc_d_test_main --verbose --desc opt " {
  run rc_d_test_main --verbose --desc opt
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

@test "rc_d_test_main --help: Error " {
  run rc_d_test_main --help
  assert_failure
}

@test "rc_d_test_main --version: Error " {
  run rc_d_test_main --help
  assert_failure
}

@test "rc_d_test_main --man-repo: Error " {
  run rc_d_test_main --help
  assert_failure
}

@test "rc_d_test_main --debug --dryrun --quiet --verbose --warning -- bash version " {
  run rc_d_test_main --debug --dryrun --quiet --verbose --warning -- bash version
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

@test "rc_d_test_main -parse --help opt " {
  run rc_d_test_main -parse --help opt
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

@test "rc_d_test_main -parse --desc " {
  run rc_d_test_main -parse --desc
  [ "$status" -eq 0 ]
  assert_output "$(getdesc parse)"
}
