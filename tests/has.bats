#!/usr/bin/env bats
# shellcheck disable=SC2086,SC2153

setup() {
  load helpers/test_helper
  path_link="/${TOP_NAME}/tests/fixtures/link"
}

assertlink() {
  case "${1}" in
    *alpine*|bash*|bats*|busybox*|macOS|nix*) assert_output /bin/link ;;
    *) assert_output /usr/bin/link ;;
  esac
}

assertlinka() {
  case "${1}" in
    *alpine*|bash*|bats*|busybox*|macOS|nix*) assert_line /bin/link ;;
    *) assert_line /usr/bin/link ;;
  esac

  case "${1}" in
    macOS) assert_line "${HOME}${path_link}" ;;
    *) assert_line "${path_link}" ;;
  esac
}

assertlinkv() {
  p="${path_link}"
  if [ "${1}" = 'macOS' ]; then
    p="${HOME}${path_link}"
  fi
  assert_output "${p}"
  unset p
}

assertoutput() {
  os="${1:-macOS}"
  description "${os}"
  sh='sh'
  [ "${os}" = 'macOS' ] || { add="'"; sh="container ${os} ${sh}"; }
  # run sh -c "'${cmd} ${*}'"  # macOS
  # run container "${os}" "sh -c '${cmd} ${*}'"  # image
  run ${sh} -c "${add:-}${FIXTURE:+. has-${FIXTURE}.lib &&} . helpers.lib && ${BATS_TEST_DESCRIPTION}${add:-}"

  if [ "${ERROR-}" ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${LINK-}" ]; then
    assertlink "${os}"
  elif [ "${LINK_A-}" ]; then
    assertlinka "${os}"
  elif [ "${LINK_V-}" ]; then
    assertlinkv "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED}"
  fi
}

cmd() {
  assertoutput
  { ! $BATS_DOCKER || [ "${1:-}" = 'local' ]; } || for i in ${IMAGES}; do assertoutput "${i}"; done
}

@test "has" { FIXTURE='sudo'; cmd local; }
@test "has --value" { EXPECTED="alias sudo='sudo'"; FIXTURE='sudo'; cmd local; }
@test "has sudo" { unset EXPECTED; FIXTURE='sudo'; cmd local; }
@test "has --value sudo" { EXPECTED="alias sudo='sudo'"; FIXTURE='sudo'; cmd local; }
@test "has --path sudo" { unset EXPECTED; FIXTURE='sudo'; cmd local; }
@test "has --value --path sudo" { EXPECTED="$(which sudo)"; FIXTURE='sudo'; cmd local; }

@test "has foo" { unset EXPECTED; FIXTURE='foo'; cmd; }
@test "has --path foo" { ERROR=1; FIXTURE='foo'; cmd; }

@test "boo" { ERROR=1; FIXTURE='boo'; cmd; }

@test "has link" { unset ERROR; unset EXPECTED; FIXTURE='link'; cmd; }
@test "has --value link" { EXPECTED="alias link='link'"; FIXTURE='link'; cmd; }
@test "has --path link" { unset EXPECTED; FIXTURE='link'; cmd; }
@test "has --value --path link" { LINK_V=1; FIXTURE='link'; cmd; }
@test "has --all link" { LINK_A=1; FIXTURE='link'; cmd; }
@test "link" { LINK=1; unset FIXTURE; cmd; }
