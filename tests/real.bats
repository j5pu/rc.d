#!/usr/bin/env bats
# shellcheck disable=SC2001

setup() {
  load helpers/test_helper
}

assertoutput() {
  os="${1:-macOS}"
  description "${os}"
  if [ "${os}" = 'macOS' ]; then
    run sh -c "${cmd}"
  else
    run container "${os}" "sh -c '${cmd}'"
  fi

  if [ "${ERROR-}" ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${CALLBACK-}" ]; then
    $(echo "${BATS_TEST_DESCRIPTION}" | sed 's/ /::/g') "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED}"
  fi
}

cmd() {
  assertoutput
  ! $BATS_DOCKER || for i in ${IMAGES}; do assertoutput "${i}"; done
}

@test 'real' { EXPECTED='/'; cmd='cd / && real'; cmd; }

@test 'real bin' { EXPECTED='/bin'; cmd='cd / && real bin'; cmd; }
real::resolved::bin() {
  case "${1}" in
    *alpine*|bash*|bats*|busybox*|debian*|macOS|nix*|python*|zsh*) assert_output /bin ;;
    *) assert_output /usr/bin ;;
  esac
}
@test 'real resolved bin' { CALLBACK=1; cmd='cd / && real --resolved bin'; cmd; }

@test 'real tmp' { unset CALLBACK; EXPECTED='/tmp'; cmd='cd / && real tmp'; cmd; }
real::resolved::tmp() {
  case "${1}" in macOS) assert_output /private/tmp ;; *) assert_output /tmp ;; esac
}
@test 'real resolved tmp' { CALLBACK=1; cmd='real --resolved /tmp'; cmd; }

@test 'real tmp file' { unset CALLBACK; EXPECTED='/tmp/file'; cmd='cd /tmp && real file'; cmd; }
real::resolved::tmp::file() {
  case "${1}" in macOS) assert_output /private/tmp/file;; *) assert_output /tmp/file;; esac
}
@test 'real resolved tmp file' { CALLBACK=1; cmd='real --resolved /tmp/file'; cmd; }

real::fail::tmp::file() {
  assert_line --regexp 'x.*Directory or File not Found.*$'
}
@test 'real fail tmp file' { CALLBACK=1; ERROR=1; cmd='cd /tmp && real --fail file'; cmd; }
real::fail::resolved::tmp::file() {
  real::fail::tmp::file
}
@test 'real fail resolved tmp file' { CALLBACK=1; ERROR=1; cmd='real --fail --resolved  /tmp/file'; cmd; }

real::fail::quiet::tmp::file() {
  assert_output ''
}
@test 'real fail quiet tmp file' { CALLBACK=1; ERROR=1; cmd='cd /tmp && real --fail --quiet file'; cmd; }
real::fail::resolved::quiet::tmp::file() {
  assert_output ''
}
@test 'real fail resolved quiet tmp file' { CALLBACK=1; ERROR=1; cmd='real --fail --resolved --quiet /tmp/file'; cmd; }

real::tmp::dir::file() {
  assert_line --regexp 'x.*Directory not Found.*$'
}
@test 'real tmp dir file' { CALLBACK=1; ERROR=1; unset EXPECTED; cmd='cd /tmp && real dir/file'; cmd; }
real::resolved::tmp::dir::file() {
  real::tmp::dir::file
}
@test 'real resolved tmp dir file' { CALLBACK=1; ERROR=1; cmd='real --resolved /tmp/dir/file'; cmd; }

real::quiet::tmp::dir::file() {
  assert_output ''
}
@test 'real quiet tmp dir file' { CALLBACK=1; ERROR=1; unset EXPECTED; cmd='cd /tmp && real --quiet dir/file'; cmd; }
real::resolved::quiet::tmp::dir::file() {
  assert_output ''
}
@test 'real resolved quiet tmp dir file' { CALLBACK=1; ERROR=1; cmd='real --resolved --quiet /tmp/dir/file'; cmd; }

real::resolved::tmp::d3::f2() {
  f=/tmp/d1/f1; case "${1}" in macOS) assert_output "/private${f}" ;; *) assert_output "${f}" ;; esac
}
@test 'real resolved tmp d3 f2' { CALLBACK=1; cmd='real-create && cd /tmp && real --resolved d3/f2 && real-rm'; cmd; }
real::resolved::tmp::d2::f2() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d2 f2' { CALLBACK=1; cmd='real-create && cd /tmp && real --resolved d2/f2 && real-rm'; cmd; }
real::resolved::tmp::d2::f1() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d2 f1' { CALLBACK=1; cmd='real-create && cd /tmp && real --resolved d2/f1 && real-rm'; cmd; }
real::resolved::tmp::d1::f2() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d1 f2' { CALLBACK=1; cmd='real-create && cd /tmp && real --resolved d1/f2 && real-rm'; cmd; }
