#!/usr/bin/env bats
# shellcheck disable=SC2086

setup() {
  load test_helper
  . os.lib
}

@test "\$MACOS " {
  if ! $MACOS; then
    skip Linux
  fi
  assert $MACOS
}

@test "! \$MACOS " {
  if $MACOS; then
    skip macOS
  fi
  assert false
}
