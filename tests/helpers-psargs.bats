#!/usr/bin/env bats


setup() {
  load helpers/test_helper
}

@test "psargs " {
  . helpers.lib
  run psargs
  [ "$status" -eq 0 ]
  assert_line --regexp "^bash"
}
