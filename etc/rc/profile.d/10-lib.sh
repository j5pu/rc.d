# shellcheck shell=sh
#
# RC base shell lib

# ###################################### + debug: DEBUG (default: unset), QUIET (default: unset)
# Show info message with > symbol in grey bold if DEBUG is set, unless QUIET is set
# Globals:
#   DEBUG              Show if DEBUG set, unless QUIET is set (default: unset).
#   GreyDim            Grey dimmed color for info message and > symbol.
#   QUIET              Do not show message if set, takes precedence over DEBUG (default: unset).
#   Reset              Reset color.
# Arguments:
#   Message            Message to show in grey bold with > symbol.
# Output:
#   Message to stdout.
#######################################
# TODO: variables and caller
debug() { [ "${QUIET-}" ] || { [ ! "${DEBUG-}" ] || printf '%b\n' "${GreyDim}+ $*${Reset}"; }
}



####################################### ✓ long
# Long options parser.
# Arguments:
#   --usage             Show help message and exit.
# Output:
#   Man page with no pager to stdout.
# Returns:
#   1 if --usage.
#######################################
# TODO: long options
long() {
  for arg do
    case "${arg}" in
      --usage)
        if has caller && has man; then
          # shellcheck disable=SC3044
          c="$(caller 0)"
          if [ "${c-}" ]; then
            if ! man -p cat "$(basename "$(echo "${c}" | awk '{ print $3 }')")" 2>/dev/null; then
              func="$(echo "${c}" | awk '{ print $2 }')"
              { [ "${func}" != 'main' ] && man -p cat "${func}" 2>/dev/null; } || exit 1
            fi
          elif [ "${FUNCNAME[0]-}" ]; then
            # shellcheck disable=SC3054
            man -p cat "${FUNCNAME[0]}" 2>/dev/null || exit 1
          else
            exit 1
          fi
        fi
        unset arg c func
        exit 1
        ;;
    esac
  done
}

####################################### rebash
# Rebash
# Optional Arguments:
#   --force
# Returns:
#   1 if argument not empty or not --force.
#######################################
# shellcheck disable=SC2240
rebash() { . "${BASH_ENV}" "${1}"; }

# shellcheck disable=SC3045
[ ! "${BASH_VERSION-}" ] || export -f  rebash
