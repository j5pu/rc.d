#!/bin/bash
# shellcheck disable=SC2034

. bats.lib 2>/dev/null || . "${BATS_TEST_DIRNAME}/../bin/bats.lib"
FIXTURES="${BATS_TEST_DIRNAME}/fixtures"
FIXTURES_RC="${FIXTURES}/rc_d_test"
