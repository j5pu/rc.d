#!/bin/bash

if [ "${BATS_TEST_DIRNAME-}" ]; then
. "${BATS_TEST_DIRNAME}/../bin/bats.lib"
else
.  "$(git top)/bin/bats.lib"
fi
