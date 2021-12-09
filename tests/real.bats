#!/usr/bin/env bats

load lib/test_helper
setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
}

@test "${BATS_HEADER} real" {
  skip
  run real
  [ "$status" -eq 0 ]
}
