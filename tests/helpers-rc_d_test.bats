#!/usr/bin/env bats

setup() {
  load helpers/test_helper
  setup_rc_d_test
  . rc_d_test.lib
}

assertoutput() {
  description "${os}" "${cmd}"
  [ "${os}" = 'macOS' ] || { add="'"; SH="container ${os} ${SH}"; }
  # run sh -c "'${cmd} ${*}'"  # macOS
  # run container "${os}" "sh -c '${cmd} ${*}'"  # image
  if [ "${1-}" ]; then
    run ${SH} -c "${add:-}. rc_d_test.lib; ${cmd} ${*}${add:-}"
  else
    run ${SH} -c "${add:-}. rc_d_test.lib; ${cmd}${add:-}"
  fi

  [ "$status" -eq "${STATUS:-0}" ]
  assert_output - <<STDIN
${EXPECTED}
STDIN
}

cmd() {
  os="${1}"; shift
  for cmd in ${RC_D_TEST_RUN_SH}; do SH='sh' assertoutput "${*:-}"; done
  for cmd in ${RC_D_TEST_RUN_SH}; do SH='sh' assertoutput "${*:-}"; done
}

@test "rc_d_test: no args " {
  EXPECTED="$(cat <<EOF
DEBUG: ${DEBUG:-}
DRYRUN: ${DRYRUN:-}
QUIET: ${QUIET:-}
VERBOSE: ${VERBOSE:-}
WARNING: ${WARNING:-}
args: ${args:-}
EOF
  )"
  cmd macOS
  cmd alpine:latest
}
