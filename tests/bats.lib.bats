#!/usr/bin/env bats

load lib/test_helper

# TODO: Probar con docker

@test "${BATS_HEADER##*/} bats libs functions declared" {
   for func in ${BATS_LIBS_FUNCS}; do
    run declare -pF "${func}"
    [ "$status" -eq 0 ]
  done
}

@test "${BATS_HEADER##*/} bats libs dirs exists" {
   for dir in ${BATS_LIBS_DIRS}; do
    assert_exist "${dir}"
  done
}
