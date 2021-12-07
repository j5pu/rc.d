#!/usr/bin/env bats

load lib/test_helper

@test "${BATS_HEADER##*/} sh" {
  assert sh -c '. strict.lib'
}

@test "${BATS_HEADER##*/} bash 3" {
  assert /bin/bash -c '. strict.lib'
}

@test "${BATS_HEADER##*/} bash 4" {
  assert /usr/local/bin/bash -c '. strict.lib'
}

@test "${BATS_HEADER##*/} sh: shell option +e [errexit]: Off" {
  run sh -c 'test -o errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} sh: shell option -e [errexit]: On (strict.lib)" {
  assert sh -c '. strict.lib; test -o errexit'
}

@test "${BATS_HEADER##*/} bash: shell option +e [errexit]: Off" {
  run test -o errexit
  run assert_failure
}

@test "${BATS_HEADER##*/} bash: shell option -e [errexit]: On (strict.lib)" {
  assert . strict.lib; test -o errexit
}

@test "${BATS_HEADER##*/} sh: shell option +u [nounset]: Off" {
  run sh -c 'test -o nounset'
  run assert_failure
}

@test "${BATS_HEADER##*/} sh: shell option -u [nounset]: On (strict.lib)" {
  assert sh -c '. strict.lib; test -o nounset'
}

@test "${BATS_HEADER##*/} bash: shell option +u [nounset]: Off" {
  run test -o nounset
  run assert_failure
}

@test "${BATS_HEADER##*/} bash: shell option -u [nounset]: On (strict.lib)" {
  assert . strict.lib; test -o nounset
}

@test "${BATS_HEADER##*/} sh: shell option +o [pipefail]: Error" {
  run sh -c 'test -o pipefail'
  run assert_failure
}

@test "${BATS_HEADER##*/} sh: shell option -o [pipefail]: Error (strict.lib)" {
  run sh -c '. strict.lib; test -o pipefail'
  run assert_failure
}

@test "${BATS_HEADER##*/} bash: shell option +o [pipefail]: Off" {
  run test -o pipefail
  run assert_failure
}

@test "${BATS_HEADER##*/} bash: shell option -o [pipefail]: On (strict.lib)" {
  assert . strict.lib; test -o pipefail
}

@test "${BATS_HEADER##*/} sh: option -u [inherit_errexit]: Error" {
  run sh -c 'shopt -pq inherit_errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} sh: option -s [inherit_errexit]: Error (strict.lib)" {
  run sh -c '. strict.lib; shopt -pq inherit_errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} bash 3: option -u [inherit_errexit]: Error" {
  run /bin/bash -c 'shopt -pq inherit_errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} bash 3: option -s [inherit_errexit]: Error (strict.lib)" {
  run /bin/bash -c '. strict.lib; shopt -pq inherit_errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} bash 4: option -u [inherit_errexit]: Disable" {
  run /usr/local/bin/bash -c 'shopt -pq inherit_errexit'
  run assert_failure
}

@test "${BATS_HEADER##*/} bash 4: option -s [inherit_errexit]: Enable" {
  assert /usr/local/bin/bash -c 'shopt -s inherit_errexit; shopt -pq inherit_errexit'
}

@test "${BATS_HEADER##*/} bash 4: option -s [inherit_errexit]: Enable (strict.lib)" {
  assert /usr/local/bin/bash -c '. strict.lib; shopt -pq inherit_errexit'
}
