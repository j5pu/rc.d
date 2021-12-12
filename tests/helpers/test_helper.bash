#!/bin/bash
# bashsupport disable=BP2001

. bats.lib 2>/dev/null || . "${BATS_TEST_DIRNAME}/../bin/bats.lib"
. colorf.lib
. os.lib

IMAGES="$(rcdocker image --base)"; export IMAGES
#INPUT="${BATS_TEST_DIRNAME}/input"
#RC_D_TEST_NAME="rc_d_test"

alpine() {
  docker run -it -v "${BATS_TOP}/bin:/usr/local/bin" --entrypoint /bin/sh alpine -c '. /rc.d/bin/os.lib; env'
  docker run -it -v "${PWD}"/bin:/usr/local/bin --entrypoint sh alpine -c color
}

container() {
  local image="${1}"
  shift
  docker run -i \
    --rm \
    -e PATH="${PATH}" \
    -e MANPATH="${MANPATH}" \
    -v "${TOP}":/"${TOP_NAME}" \
    --entrypoint /bin/sh \
    "${image}" \
    -c "${*}"
}

description() {
  echo "   [$(magenta "$(echo "${BATS_TEST_DESCRIPTION}" | awk '{ $1=$1 };1')")] [$(green "${1:-macOS}")] \
${2:+[$(blue "${2}")]}" >&3
}

detach() {
  local image="${1}"
  shift
  docker run -it \
    -e PATH="${PATH}" \
    -e MANPATH="${MANPATH}" \
    -v "${TOP}":/"${TOP_NAME}" \
    --entrypoint /bin/sh \
    "${image}"
}

getdesc() { head -1 "${INPUT}/${1}.desc"; }

is_sh() { rcdocker image --sh --base | grep -q "${1}"; }
is_bash() { rcdocker image --sh=bash --base | grep -q "${1}"; }
is_dash() { rcdocker image --sh=dash --base | grep -q "${1}"; }

setup_rc_d_test() {
#  RC_D_TEST="${BATS_TEST_DIRNAME}/${RC_D_TEST_NAME}"; export RC_D_TEST
#  PATH="${RC_D_TEST}/bin:${PATH}"; export PATH
#  MANPATH="${RC_D_TEST}/share/man${MANPATH:+:${MANPATH}}"; export MANPATH
  RC_D_TEST_RUN_BASH='rc_d_test.bash'
  RC_D_TEST_RUN_SH='rc_d_test rc_d_test_function rc_d_test_main'
  RC_D_TEST_RUN="${RC_D_TEST_RUN_SH} ${RC_D_TEST_RUN_BASH}"; export RC_D_TEST_RUN
}

