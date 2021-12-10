#!/usr/bin/env bats

setup() {
  load test_helper
  setup_rc_d_test
}

@test "manpage rc_d_test " {
  skip
  run manpage "${FIXTURES_RC}"
  [ "$status" -eq 0 ]
}
