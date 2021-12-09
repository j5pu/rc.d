#!/bin/bash

. bats.lib 2>/dev/null || . "${BATS_TEST_DIRNAME}/../bin/bats.lib"

alpine() {
  docker run -it -v "${BATS_TOP}:/code" bats/bats:latest /code/test
}

setup_rc_d_test() {
  # bashsupport disable=BP2001
  RC_D_TEST="${BATS_TEST_DIRNAME}/rc_d_test"
  PATH="${RC_D_TEST}/bin:${PATH}"
}

