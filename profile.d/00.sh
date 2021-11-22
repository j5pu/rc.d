# shellcheck shell=sh
#
# System profile & rc file.

# TODO: examples
# TODO: comprobar que las funciones se exportan en sh y zsh o en cuales
# TODO: bash-lib
# TODO: ver las funciones que realmente uso en install, porque si al final hago download del directorio
#  entonces pueden estar en bin.
export MACOS=false
UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ "${UNAME}" = "darwin" ]; then
  export MACOS=true
  eval "$(/usr/libexec/path_helper -s)"
elif [ "$(id -u)" -eq 0 ]; then
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
fi

{ [ "${0##*/}" = "sh" ] && IS_BASH=false; } || { [ -n "${BASH_VERSION}" ] && IS_BASH=true; } || [ -n "${BASH}" ] \
  || { true; exit; }; export IS_BASH
export IS_BASH

####################################### x color: unset function
# Set color globals
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
# Contain the unicode Ansi escapes (\u001b) to be used in any language, e.g. Java, Python and Javascript).
# Global vars
#   <Name>                 Color foreground.
#   <Name>Bg               Color background.
#   <Name>Bold             Color bold/bright.
#   <Name>Dim              Color dimmed.
#   <Name>Under            Color underscored.
#   COLORS                 All color (Black Red Green Yellow Blue Magenta Cyan White) combinations.
#   Reset                  Reset color.
# Arguments:
#   None
# ######################################
# shellcheck disable=SC2034
color() {
  c() { [ "${COLORS-}" ] && s=" "; export COLORS="${COLORS}${s}${1}"; eval "export ${1}='\033[${2}${3}'"; }
  c "Reset" "0" "m"
  i="0"
  for n in Black Red Green Yellow Blue Magenta Cyan Grey; do
    c "${n}" "3${i}" "m"
    c "${n}Bold" "3${i}" ";1m"
    c "${n}Dim" "3${i}" ";2m"
    c "${n}Under" "3${i}" ";4m"
    c "${n}Invert" "3${i}" ";7m"
    c "${n}Bg" "4${i}" "m"
    i="$((i+1))"
  done; unset c i s; unset -f c
}

####################################### x constants: unset function
# Constants
# Arguments:
#   None
#######################################
constants() {
  true
}

####################################### ✓ die: exported function
# Show message (ok or error) with symbol (✓, x respectively) based on status code and exit
# Globals:
#   Green              Green color for ✓ symbol.
#   Red                Red color for error message and x symbol.
#   Reset              Reset color.
# Arguments:
#   -h, --help         Show help message and exit.
#   message            Message to show.
# Output:
#   Message to stderr if error and stdout for ok.
#   Help message to stdout.
# Returns:
#   1-255 for error, 0 for ok.
#######################################
die() {
  rc=$?
  helpin "${@}" || exit 1
  case "${rc}" in
    0) ok "${@}" ;;
    *) err "${@}" ;;
  esac
  exit "${rc}"
}

####################################### ✓ helpin: exported function
# Show man page (no pager) and die if --help or -h in arguments, checks caller filename otherwise caller function name.
# Arguments:
#   -h, --help:            Show help message and exit.
# Output:
#   Man page with no pager to stdout.
# Returns:
#   1 if -h or --help and no man page.
#######################################
helpin() {
  for arg do
    case "${arg}" in
      -h|--help)
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
        exit
        ;;
    esac
  done
}


###################################### > functions: run
# run functions
######################################
for i in color constants vars; do
  ${i}
done

###################################### > functions: export
# export functions
######################################
for i in die; do
  # shellcheck disable=SC3045
  export -f "${i?}" 2>/dev/null || true
done

###################################### > functions: unset
# export functions
######################################
for i in color constants; do
  unset -f "${i}"
done; unset i
