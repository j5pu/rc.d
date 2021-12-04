#!/usr/bin/env bats

load lib/test_helper

@test "bats_libs_declared" {
   for func in ${_BATS_LIBS_FUNCS}; do
    run declare -pF "${func}"
    [ "$status" -eq 0 ]
  done
}

@test "bats_libs_dirs" {
   for dir in ${_BATS_LIBS_DIRS}; do
    assert_exist "${dir}"
  done
}
