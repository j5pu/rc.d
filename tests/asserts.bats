#!/usr/bin/env bats

load lib/test_helper

@test "${BATS_HEADER} status" {
   for func in ${BATS_LIBS_FUNCS}; do
    run declare -pF "${func}"
    [ "$status" -eq 0 ]
  done
}

@test "${BATS_HEADER} assert_success" {
   for func in ${BATS_LIBS_FUNCS}; do
    run declare -pF "${func}"
    [ "$status" -eq 0 ]

    run declare -pF "${func}"
    run assert_success

    assert declare -pF "${func}"
  done
}

@test "${BATS_HEADER} assert" {
   for func in ${BATS_LIBS_FUNCS}; do
    assert declare -pF "${func}"
  done
}

@test "${BATS_HEADER} assert_failure" {
  run false
  assert_failure
}

@test "${BATS_HEADER} assert_exist" {
   for dir in ${BATS_LIBS_DIRS}; do
    assert_exist "${dir}"
  done
}

@test "${BATS_HEADER} assert_line & assert_output" {
  run printf '%s\n' 1 2 3
  [ "$status" -eq 0 ]
  assert_line '2'
  assert_output - <<STDIN
1
2
3
STDIN
}

@test "${BATS_HEADER} assert_line() looking for line" {
   run echo $'have-0\nhave-1\nhave-2'
   assert_line 'have-1'
 }

@test "${BATS_HEADER} assert_line() partial matching" {
 run echo $'have 1\nhave 2\nhave 3'
 assert_line --partial 'have'
}

@test "${BATS_HEADER} assert_line() <expected>: returns 0 if <expected> is a line in \`\${lines[@]}'" {
  run printf 'a\nb\nc'
  assert_line --index 1 'b'
}

@test "${BATS_HEADER} assert_line() --regexp <regexp>: enables regular expression matching" {
  run printf 'a\n_b_\nc'
  assert_line --regexp '^_'
}
