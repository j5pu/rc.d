#!/usr/bin/env bats

setup() {
  load test_helper
}

@test "sh" {
  assert sh -c '. strict.lib'
}

@test "bash 3" {
  assert /bin/bash -c '. strict.lib'
}

@test "bash 4" {
  assert /usr/local/bin/bash -c '. strict.lib'
}

@test "sh: shell option +e [errexit]: Off" {
  run sh -c 'test -o errexit'
  assert_failure
}

@test "sh: shell option -e [errexit]: On (strict.lib)" {
  assert sh -c '. strict.lib; test -o errexit'
}

@test "bash: shell option +e [errexit]: Off" {
  run test -o errexit
  assert_failure
}

@test "bash: shell option -e [errexit]: On (strict.lib)" {
  assert . strict.lib; test -o errexit
}

@test "sh: shell option +u [nounset]: Off" {
  run sh -c 'test -o nounset'
  assert_failure
}

@test "sh: shell option -u [nounset]: On (strict.lib)" {
  assert sh -c '. strict.lib; test -o nounset'
}

@test "bash: shell option +u [nounset]: Off" {
  run test -o nounset
  assert_failure
}

@test "bash: shell option -u [nounset]: On (strict.lib)" {
  assert . strict.lib; test -o nounset
}

@test "sh: shell option +o [pipefail]: Error" {
  run sh -c 'test -o pipefail'
  assert_failure
}

@test "sh (macos): shell option -o [pipefail]: On (strict.lib)" {
  assert sh -c '. strict.lib; test -o pipefail'
}

@test "bash: shell option +o [pipefail]: Off" {
  run test -o pipefail
  assert_failure
}

@test "bash: shell option -o [pipefail]: On (strict.lib)" {
  assert . strict.lib; test -o pipefail
}

@test "sh: option -u [inherit_errexit]: Error" {
  run sh -c 'shopt -pq inherit_errexit'
  assert_failure
}

@test "sh: option -s [inherit_errexit]: Error (strict.lib)" {
  run sh -c '. strict.lib; shopt -pq inherit_errexit'
  assert_failure
}

@test "bash 3: option -u [inherit_errexit]: Error" {
  run /bin/bash -c 'shopt -pq inherit_errexit'
  assert_failure
}

@test "bash 3: option -s [inherit_errexit]: Error (strict.lib)" {
  run /bin/bash -c '. strict.lib; shopt -pq inherit_errexit'
  assert_failure
}

@test "bash 4: option -u [inherit_errexit]: Disable" {
  run /usr/local/bin/bash -c 'shopt -pq inherit_errexit'
  assert_failure
}

@test "bash 4: option -s [inherit_errexit]: Enable" {
  assert /usr/local/bin/bash -c 'shopt -s inherit_errexit; shopt -pq inherit_errexit'
}

@test "bash 4: option -s [inherit_errexit]: Enable (strict.lib)" {
  assert /usr/local/bin/bash -c '. strict.lib; shopt -pq inherit_errexit'
}
