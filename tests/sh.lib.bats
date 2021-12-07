#!/usr/bin/env bats

load lib/test_helper

@test "${BATS_HEADER##*/} functions declared" {
   for func in ${BATS_LIBS_FUNCS}; do
    run declare -pF "${func}"
    [ "$status" -eq 0 ]
  done
}

@test "${BATS_HEADER##*/} dirs exists" {
   for dir in ${BATS_LIBS_DIRS}; do
    assert_exist "${dir}"
  done
}
