# shellcheck shell=sh disable=SC3053
#
# RC base shell lib

[ "${__PROFILE_SOURCE_IT-}" ] || { return 0 2>/dev/null || exit 0; }

#######################################
# Show colors
# Globals:
#   COLORS            Color names available.
# Outputs:
#   Colors to stdout
#######################################
colors() {
  if [ "${BASH_VERSION-}" ]; then
    for i in ${COLORS:?}; do
      printf "%b\n" "${!i}${i}${Reset}"
    done
  fi
  # TODO: test cases
  debug Debug Message: not shown DEBUG=1
  DEBUG=1 debug Debug Message: DEBUG=1
  error Error Message
  success Success Message
  QUIET=1 success Success Message: not shown QUIET=1
  DRYRUN=1 verbose Dry-run Message: DRYRUN=1
  unset DRY_RUN
  VERBOSE=1 verbose Verbose Message: VERBOSE=1
  WARNING=1 warning Warning Message: WARNING=1
  false || die Die with Error Message
}

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

####################################### ✓|x die: QUIET (default: unset)
# Show message (ok or error) with symbol (✓, x respectively) based on status code, unless QUIET is set and exit
# Globals:
#   Green              Green color for ✓ symbol.
#   QUIET              Do not show message if set (default: unset).
#   Red                Red color for error message and x symbol.
#   Reset              Reset color.
# Arguments:
#   message            Message to show.
# Output:
#   Message to stderr if error and stdout for ok.
# Returns:
#   1-255 for error, 0 for ok.
#######################################
die() {
  rc=$?
  case "${rc}" in
    0) ok "${@}" ;;
    *) error "${@}" ;;
  esac
  exit "${rc}"
}

####################################### x error: QUIET (default: unset)
# Show error message with x symbol in red, unless QUIET is set
# Globals:
#   QUIET              Do not show message if set (default: unset).
#   Red                Red color for error message and x symbol.
#   Reset              Reset color.
# Arguments:
#   Message            Message to show in red with x symbol.
# Output:
#   Message to stderr.
#######################################
error() {
  if [ ! "${QUIET-}" ]; then
    if hasc caller; then
      c="$(caller 0)"
      if [ "$(echo "${c}" | awk '{ print $2 }')" = "die" ]; then c="$(caller 1)"; fi
      add="${RedDim}$(basename "$(echo "${c}" | awk '{ print $3 }')")[$(echo "${c}" | awk '{ print $1 }')]${Reset} "
    fi
    printf '%b\n' "${Red}x${Reset} ${add}${Red}$*${Reset}" >&2
    unset add c
  fi
}

#######################################
# Check if an executable exists (which) excluding rc SBIN
# Arguments:
#   -c                  Use command instead of which.
#   -v                  Show path.
#   --usage             Show help message and exit.
#   executable          Executable to check.
# Returns:
#   1 if does not exists.
# Output:
#   Help message to stdout.
#######################################
has() {
  cmd="which"
  v=false
  for arg; do
    case "${arg}" in
      -c) c=1; cmd="command" ;;
      -v) v=true ;;
      --usage) usage "${@}" || exit ;;
      *) exe="${arg}";;
    esac
  done

  p="${PATH}"
  PATH="$(echo "${PATH}" | sed "s/${SBIN}://g")"
  if $v; then
    rv="$(${cmd} ${c:+-v} "${exe}")"
  else
    ${cmd} "${exe}" 1>/dev/null
  fi
  rc=$?; PATH="${p}"; [ ! "${rv-}" ] || echo "${rv}"; { return "${rc}" 2>/dev/null || exit "${rc}"; }
}

####################################### is
# Is root, sudo or user
# Arguments:
#   root             id is 0.
#   sudo             SUDO_UID set.
#   user             not root and not user.
# Output:
#   Help message to stdout.
# Returns:
#   1 if no root, sudo or user.
#######################################
is() {
  case "${1}" in
    root) [ "$(id -u)" -eq 0 ] ;;
    sudo) [ "${SUDO_UID-}" ] ;;
    user) ! is root && ! is sudo ;;
  esac
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

####################################### ✓ ok: QUIET (default: unset)
# Show ok message in white with green ✓ symbol, unless QUIET is set
# Globals:
#   Green              Green color for ✓ symbol.
#   QUIET              Do not show message if set (default: unset).
#   Reset              Reset color.
# Arguments:
#   --usage            Show help message and exit.
#   Message            Message to show in white with green ✓ symbol.
# Output:
#   Message to stdout. success
#######################################
ok() { [ "${QUIET-}" ] || printf '%b\n' "${Green}✓${Reset} $*"; }

####################################### rebash
# Rebash
# Optional Arguments:
#   --force
# Returns:
#   1 if argument not empty or not --force.
#######################################
rebash() { { [ "${1-}" ] && [ "${1}" != "--force" ]; } || . /etc/profile "${1}"; }

####################################### ✓ real: exported function
# Absolute logical (symlink) or resolved (physical) path (if does not exists, accepts one level up to cd).
# Arguments:
#   -l, --logical       Do not resolve symlinks (pwd)
#   path                  Path (default: cwd).
# Output:
#   Path or help message to stdout.
# Returns:
#   1 if parent directory does not exists.
#######################################
real() {
  logical=false

  for arg do
    case "${arg}" in
      -l|--logical) logical=true ;;
      *) relative="${arg}"
    esac
  done

  relative="${relative-.}"
  [ -d "${relative}" ] || basename="/$(basename "${relative}")"  # does not exists or is file
  cd "$(dirname "${relative}")" || exit 1

  if $logical; then
    echo "$(pwd)${basename}"
  else
    echo "$(pwd -P)${basename}"
  fi
  unset arg basename logical relative
}



####################################### > verbose: VERBOSE/DRY_RUN (default: unset), QUIET (default: unset)
# Show verbose/dry-run message with > symbol in grey dim if VERBOSE or DRY_RUN are set, unless QUIET is set
# Globals:
#   DRY_RUN            Shows message if set, unless QUIET is set (default: unset).
#   VERBOSE            Shows message if set, unless QUIET is set (default: unset).
#   GreyDim            Grey dimmed color for info message and > symbol.
#   QUIET              Do not show message if set, takes precedence over VERBOSE/DRY_RUN (default: unset).
#   Reset              Reset color.
# Arguments:
#   Message            Message to show in grey bold with > symbol.
# Output:
#   Message to stdout.
#######################################
verbose() { { [ ! "${VERBOSE-}" ] || [ ! "${DRY_RUN-}" ]; } || printf '%b\n' "${GreyDim}> $*${Reset}"; }

####################################### > warning: WARNING (default: unset), QUIET (default: unset)
# Show warning message with ! symbol in yellow if WARNING is set, unless QUIET is set
# Globals:
#   Yellow             Yellow color for warning message and ! symbol.
#   Reset              Reset color.
#   QUIET              Do not show message if set, takes precedence over WARNING (default: unset).
#   WARNING            Shows message if is set, unless QUIET is set (default: unset).
# Arguments:
#   --usage            Show help message and exit.
#   Message            Message to show in yellow with ! symbol.
# Output:
#   Message to stderr.
#######################################
warning() {
  if [ ! "${QUIET-}" ]; then
    if [ "${WARNING-}" ]; then
      if hasc caller; then
        c="$(caller 0)"
        if [ "$(echo "${c}" | awk '{ print $2 }')" = "die" ]; then c="$(caller 1)"; fi
        add="${YellowDim}$(basename "$(echo "${c}" | awk '{ print $3 }')")\
[$(echo "${c}" | awk '{ print $1 }')]${Reset} "
      fi
      printf '%b\n' "${Yellow}x${Reset} ${add}${Yellow}$*${Reset}" >&2
      unset add c
    fi
  fi
}

[ "${SH-}" ] || export -f colors debug die has is error ok real rebash verbose warning
