#!/usr/bin/env bats

# Variables from test_helper not available outside @test, so images not available in 'while' if setup()
setup() {
  load helpers/test_helper
}

assertline () {
  ASSERT="${ASSERT_BASH:-${ASSERT_SH}}"
  COMMAND="${COMMAND_BASH:-color}"
  ! echo "${1}" | grep -qE 'centos' || skip=1
  description "${1:-}"
  if [ "${1}" ]; then
    is_bash "${1}" || { ASSERT="${ASSERT_SH}"; COMMAND="${COMMAND_SH:-color}"; }
    [ "${skip-}" ] || run container "${1}" "${COMMAND}"
  else
    run ${COMMAND_MAC:-${COMMAND}} "${ARGS}"
  fi

  if [ ! "${skip-}" ]; then
    [ "$status" -eq "${STATUS:-0}" ]
    ${REFUTE:-assert_line --regexp} "${ASSERT}"
  fi
}

@test "color: + VAR1=1, VAR2=2 " {
  ASSERT_BASH='\+.*color\[.*].*: .*VAR1=1,.*$'  # + color.lib[xx]: VAR1=1, VAR2=2
  ASSERT_SH='\+.*VAR1=1,.*$'  # + VAR1=1, VAR2=2
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: + VAR1=1 " {
  ASSERT_BASH="\+.*color\[.*].*: .*VAR1=1\
"  # + color.lib[xx]: VAR1=1
  ASSERT_SH="\+.*VAR1=1\
"  # + VAR1=1
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: + " {
  ASSERT_BASH="\+.*color\[.*].*\
"  # + color.lib[xx]
  ASSERT_SH="\+.*\
"  # +
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: x Error Message " {
  ASSERT_BASH='x.*color\[.*].*: .*Error Message.*$'  # x color[88]: Error Message
  ASSERT_SH='x.*Error Message.*$'  # x Error Message
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: x " {
  ASSERT_BASH="x.*color\[.*].*\
"  # x color.lib[xx]
  ASSERT_SH="x.*\
"  # x
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: ok Success Message " {
  ASSERT_SH='✓*Success Message.*$'  # ✓ Ok Message
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: ok " {
  ASSERT_SH="✓.*$\
"  # ✓
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: > Verbose Message: VERBOSE=1 " {
  ASSERT_SH='>*Verbose Message: VERBOSE=1.*$'  # > Verbose Message: VERBOSE=1
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: > " {
  ASSERT_SH=">.*$\
"  # >
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: ! Warning Message: WARNING=1 " {
  ASSERT_BASH='!.*color\[.*].*: .*Warning Message: WARNING=1.*$'  # ! color[xx]: Warning Message: WARNING=1
  ASSERT_SH='!.*Warning Message: WARNING=1.*$'  # ! Warning Message: WARNING=1
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: ! " {
  ASSERT_BASH="!.*color\[.*].*$\
"  # ! color[xx]
  ASSERT_SH="!.*$\
"  # !
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: ok Die Message " {
  ASSERT_SH='✓*Die Message.*$'  # ✓ Die Message
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: Not Shown " {
  ASSERT_SH='Not Shown' #
  REFUTE='refute_line --partial'
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}

@test "color: bash -c 'false || die Die: Error Message' " {
  ASSERT_BASH='x.*bash\[].*: .*Die: Error Message.*$'  # x color[xx]: Die: Error Message
  ASSERT_SH='x.*Die: Error Message.*$'  # x Die: Error Message
  ARGS=". helpers.lib; false || die Die: Error Message"
  COMMAND_BASH="bash -c '${ARGS}'"
  COMMAND_SH="sh -c '${ARGS}'"
  COMMAND_MAC="bash -c"
  STATUS=1
  assertline
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertline "${i}"; done
}
