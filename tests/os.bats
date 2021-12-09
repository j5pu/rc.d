#!/usr/bin/env bats
# shellcheck disable=SC2086

load lib/test_helper

setup() {
  . os.lib
}

@test "${BATS_HEADER} \$MACOS" {
  if ! $MACOS; then
    skip Linux
  fi
  assert $MACOS
}
