#!/usr/bin/env bats

load lib/test_helper
setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
}

@test "${BATS_HEADER} colon" {
  skip
  run colon
  [ "$status" -eq 0 ]
}
