#!/usr/bin/env bats

setup() {
  load helpers/test_helper
}

@test "real " {
  skip
  run real
  [ "$status" -eq 0 ]
}
