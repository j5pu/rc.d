#!/bin/bash

# rc_d_test.bash is a test script in bash with main() function
#
STRICT=1 . helpers.lib

main() {
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
  else
    parse "${@:-}"
  fi
}

main "$@"
