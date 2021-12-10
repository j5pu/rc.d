#!/usr/bin/env bats

setup() {
  load test_helper
}

@test "colon " {
  skip
  run colon
  [ "$status" -eq 0 ]
}
