#!/usr/bin/env bats

load lib/test_helper

setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
}

@test "${BATS_HEADER} psargs" {
  . helpers.lib
  run psargs
  [ "$status" -eq 0 ]
  assert_line --regexp "^bash"
}
