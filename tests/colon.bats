#!/usr/bin/env bats

setup() {
  load helpers/test_helper
}

@test "colon " {
  skip
  run colon
  [ "$status" -eq 0 ]
}
