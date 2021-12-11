#!/usr/bin/env bats

setup() {
  load test_helper
}

@test "functions declared " {
   for func in ${BATS_LIBS_FUNCS}; do
    assert declare -pF "${func}"
  done
}

@test "dirs exists " {
   for dir in ${BATS_LIBS_DIRS}; do
    assert_exist "${dir}"
  done
}
