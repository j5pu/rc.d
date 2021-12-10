#!/bin/bash
# bashsupport disable=BP2001

. bats.lib 2>/dev/null || . "${BATS_TEST_DIRNAME}/../bin/bats.lib"
. colorf.lib

IMAGES="$(rcdocker image --base)"; export IMAGES

alpine() {
  docker run -it -v "${BATS_TOP}/bin:/usr/local/bin" --entrypoint /bin/sh alpine -c '. /rc.d/bin/os.lib; env'
  docker run -it -v "${PWD}"/bin:/usr/local/bin --entrypoint sh alpine -c color
}


container() {
  local image="${1}"
  shift
  docker run -i --rm \
    -e PATH="$(colon /"${BATS_TOP_NAME}/bin" "$(colon --base)")" \
    -v "${BATS_TOP}":/"${BATS_TOP_NAME}" \
    --entrypoint /bin/sh \
    "${image}" \
    -c "${*}"
}

description() { echo "   - ${BATS_TEST_DESCRIPTION}: $(green "${1:-macOS}")" >&3; }

is_sh() { rcdocker image --sh --base | grep -q "${1}"; }
is_bash() { rcdocker image --sh=bash --base | grep -q "${1}"; }
is_dash() { rcdocker image --sh=dash --base | grep -q "${1}"; }

setup_rc_d_test() {
  RC_D_TEST="${BATS_TEST_DIRNAME}/rc_d_test"; export RC_D_TEST
  PATH="${RC_D_TEST}/bin:${PATH}"; export PATH
  MANPATH="${RC_D_TEST}/share/man${MANPATH:+:${MANPATH}}"; export MANPATH
}

