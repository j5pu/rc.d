#!/usr/bin/env bats

load lib/test_helper
setup() {
  PATH="${FIXTURES_RC}/bin:${PATH}"
}

@test "${BATS_HEADER} manpage rc_d_test" {
  skip
  run manpage "${FIXTURES_RC}"
  [ "$status" -eq 0 ]
}
