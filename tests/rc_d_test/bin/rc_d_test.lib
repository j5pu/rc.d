# shellcheck shell=sh disable=SC3045

# rc_d_test.lib is a test library with one function rc_d_test_function
#
. helpers.lib

rc_d_test_function() {
  if [ "${PARSED-}" ] && unset PARSED; then
    echo "DEBUG: ${DEBUG:-}"
    echo "DRYRUN: ${DRYRUN:-}"
    echo "QUIET: ${QUIET:-}"
    echo "VERBOSE: ${VERBOSE:-}"
    echo "WARNING: ${WARNING:-}"
    echo "args: $*"

    for arg do
      case "${arg}" in
        -h|--help) echo "Another help: ${arg}" ;;
        --other-option) echo "${arg}" ;;
        *) echo "${arg}" ;;
      esac
    done
    unset arg
  else
    DESC="rc d test function is a test function in rc.d.test.lib" PARSE='rc_d_test_function' parse "$@"
  fi
}
