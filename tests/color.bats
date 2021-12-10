#!/usr/bin/env bats

# Variables from test_helper not available outside @test, so images not available in while if setup()
setup() {
  load test_helper
}

@test "color: + VAR1=1, VAR2=2 " {
  description
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]: VAR1=1, VAR2=2
  assert_line --regexp '\+.*color\[.*].*: .*VAR1=1,.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    if is_sh "${i}"; then
      # + VAR1=1, VAR2=2
      assert_line --regexp '\+.*VAR1=1,.*$'
    else
      # + color.lib[xx]: VAR1=1, VAR2=2
      assert_line --regexp '\+.*color\[.*].*: .*VAR1=1,.*$'
    fi
  done
}


@test "color: + VAR1=1 " {
  description
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]: VAR1=1
  assert_line --regexp "\+.*color\[.*].*: .*VAR1=1\
"

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]

    if is_sh "${i}"; then
      # + VAR1=1
      assert_line --regexp "\+.*VAR1=1\
"
    else
      # + color.lib[xx]: VAR1=1
      assert_line --regexp "\+.*color\[.*].*: .*VAR1=1\
"
    fi
  done
}

@test "color: + " {
  description
  run color
  [ "$status" -eq 0 ]
  # + color.lib[xx]
  assert_line --regexp "\+.*color\[.*].*\
"

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]

    if is_sh "${i}"; then
      # +
      assert_line --regexp "\+.*\
"
    else
    # + color.lib[xx]
    assert_line --regexp "\+.*color\[.*].*\
"
    fi
  done
}

@test "color: x Error Message " {
  description
  run color
  [ "$status" -eq 0 ]
  # x color[88]: Error Message
  assert_line --regexp 'x.*color\[.*].*: .*Error Message.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]

    if is_sh "${i}"; then
      # x Error Message
      assert_line --regexp 'x.*Error Message.*$'
    else
      # x color[88]: Error Message
      assert_line --regexp 'x.*color\[.*].*: .*Error Message.*$'
    fi
  done
}

@test "color: x " {
  description
  run color
  [ "$status" -eq 0 ]
  # x color.lib[xx]
  assert_line --regexp "x.*color\[.*].*\
"

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]

    if is_sh "${i}"; then
      # x
      assert_line --regexp "x.*\
"
    else
    # x color.lib[xx]
    assert_line --regexp "x.*color\[.*].*\
"
    fi
  done

}

@test "color: ok Success Message " {
  description
  run color
  [ "$status" -eq 0 ]
  # ✓ Ok Message
  assert_line --regexp '✓*Success Message.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    # ✓ Ok Message
    assert_line --regexp '✓*Success Message.*$'
  done
}

@test "color: ok " {
  description
  run color
  [ "$status" -eq 0 ]
  # ✓
  assert_line --regexp "✓.*$\
"
  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    # ✓
    assert_line --regexp "✓.*$\
"
  done
}

@test "color: > Verbose Message: VERBOSE=1 " {
  description
  run color
  [ "$status" -eq 0 ]
  # > Verbose Message: VERBOSE=1
  assert_line --regexp '>*Verbose Message: VERBOSE=1.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    # > Verbose Message: VERBOSE=1
    assert_line --regexp '>*Verbose Message: VERBOSE=1.*$'
  done
}

@test "color: > " {
  description
  run color
  [ "$status" -eq 0 ]
  # >
  assert_line --regexp ">.*$\
"
  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    # >
    assert_line --regexp ">.*$\
"
  done
}

@test "color: ! Warning Message: WARNING=1 " {
  description
  run color
  [ "$status" -eq 0 ]
  # ! color[xx]: Warning Message: WARNING=1
  assert_line --regexp '!.*color\[.*].*: .*Warning Message: WARNING=1.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    if is_sh "${i}"; then
      # ! Warning Message: WARNING=1
      assert_line --regexp '!.*Warning Message: WARNING=1.*$'
    else
      # ! color[xx]: Warning Message: WARNING=1
      assert_line --regexp '!.*color\[.*].*: .*Warning Message: WARNING=1.*$'
    fi
  done
}

@test "color [WARNING]: x color[xx] " {
  description
  run color
  [ "$status" -eq 0 ]
  # ! color[xx]
  assert_line --regexp "!.*color\[.*].*$\
"

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    if is_sh "${i}"; then
      # !
      assert_line --regexp "!.*$\
"
    else
    # ! color[xx]
    assert_line --regexp "!.*color\[.*].*$\
"
    fi
  done
}

@test "color: ok Die Message " {
  description
  run color
  [ "$status" -eq 0 ]
  # ✓ Die Message
  assert_line --regexp '✓*Die Message.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    # ✓ Die Message
    assert_line --regexp '✓*Die Message.*$'
  done
}

@test "color: Not Shown " {
  description
  run color
  [ "$status" -eq 0 ]
  #
  refute_line --partial 'Not Shown'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" color
    [ "$status" -eq 0 ]
    #
    refute_line --partial 'Not Shown'
  done
}

@test "color: bash -c 'false || die Die: Error Message' " {
  description
  run bash -c '. helpers.lib; false || die Die: Error Message'
  [ "$status" -eq 1 ]
  assert_output --regexp 'x.*bash\[].*: .*Die: Error Message.*$'

  for i in ${IMAGES}; do
    description "${i}"
    run container "${i}" . helpers.lib; false '||' die Die: Error Message
    if is_sh "${i}"; then
      [ "$status" -eq 0 ]
      #
      assert_output --regexp 'x.*Die: Error Message.*$'
    else
      assert_output --regexp 'x.*bash\[].*: .*Die: Error Message.*$'
    fi
  done
}
