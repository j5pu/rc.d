#!/usr/bin/env bats

setup() {
  load test_helper
}

@test "color [DEBUG]: + color[xx]: VAR1=1, VAR2=2" {
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]: VAR1=1, VAR2=2
  assert_line --regexp '\+.*color\[.*].*: .*VAR1=1,.*$'
}

@test "color [DEBUG]: + color[xx]: VAR1=1" {
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]: VAR1=1
  assert_line --regexp "\+.*color\[.*].*: .*VAR1=1\
"
}

@test "color [DEBUG]: + color[xx]" {
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]
  assert_line --regexp "\+.*color\[.*].*\
"
}

@test "color [DEBUG]: x color[xx]: Error Message" {
  run color
  [ "$status" -eq 0 ]
  # x color[88]: Error Message
  assert_line --regexp 'x.*color\[.*].*: .*Error Message.*$'
}

@test "color [ERROR]: x color[xx]" {
  run color
  [ "$status" -eq 0 ]
  # x color.lib[xx]
  assert_line --regexp "\x.*color\[.*].*\
"
}

@test "color [OK]: ok Ok Message" {
  run color
  [ "$status" -eq 0 ]
  # ✓ Ok Message
  assert_line --regexp '✓*Ok Message.*$'
}

@test "color [OK]: ok" {
  run color
  [ "$status" -eq 0 ]
  # ✓
  assert_line --regexp "✓.*$\
"
}

@test "color [VERBOSE]: > Verbose Message: VERBOSE=1" {
  run color
  [ "$status" -eq 0 ]
  # > Verbose Message: VERBOSE=1
  assert_line --regexp '>*Verbose Message: VERBOSE=1.*$'
}

@test "color [VERBOSE]: >" {
  run color
  [ "$status" -eq 0 ]
  # >
  assert_line --regexp ">.*$\
"
}

@test "color [WARNING]: ! color[xx]: Warning Message: WARNING=1" {
  run color
  [ "$status" -eq 0 ]
  # ! color[xx]: Warning Message: WARNING=1
  assert_line --regexp '!.*color\[.*].*: .*Warning Message: WARNING=1.*$'
}

@test "color [WARNING]: x color[xx]" {
  run color
  [ "$status" -eq 0 ]
  # ! color[xx]
  assert_line --regexp "!.*color\[.*].*$\
"
}

@test "color: ok Die Message" {
  run color
  [ "$status" -eq 0 ]
  # ✓ Die Message
  assert_line --regexp '✓*Die Message.*$'
}

@test "color: Not Shown" {
  run color
  [ "$status" -eq 0 ]
  #
  refute_line --partial 'Not Shown'
}

@test "color: bash -c 'false || die Die: Error Message'" {
  run bash -c '. helpers.lib; false || die Die: Error Message'
  [ "$status" -eq 1 ]
  assert_output --regexp 'x.*bash\[].*: .*Die: Error Message.*$'
}
