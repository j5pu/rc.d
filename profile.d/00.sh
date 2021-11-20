# shellcheck shell=sh
#
# System profile & rc file.

# TODO: examples
# TODO: comprobar que las funciones se exportan en sh y zsh o en cuales
# TODO: bash-lib
# TODO: ver las funciones que realmente uso en install, porque si al final hago download del directorio
#  entonces pueden estar en bin.

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

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

####################################### ✓ err: exported function
# Show error message with x symbol in red
# Globals:
#   Red                 Red color for error message and x symbol.
#   Reset               Reset color.
# Arguments:
#   -h, --help          Show help message and exit.
#   Message             Message to show in red with x symbol.
# Output:
#   Message to stderr or help message to stdout.
#######################################
# shellcheck disable=SC3044
err() {
  helpin "${@}" || exit 1
  if hasc caller; then
    c="$(caller 0)"
    if [ "$(echo "${c}" | awk '{ print $2 }')" = "die" ]; then c="$(caller 1)"; fi
    add="${RedDim}$(basename "$(echo "${c}" | awk '{ print $3 }')")[$(echo "${c}" | awk '{ print $1 }')]${Reset} "
  fi
  printf '%b\n' "${Red}x${Reset} ${add}${Red}$*${Reset}" >&2
  unset add c
}

####################################### ✓ has: exported function
# Check if an executable exists (which)
# Arguments:
#   -h, --help          Show help message and exit.
#   executable          Executable to check.
# Returns:
#   1 if does not exists.
# Output:
#   Help message to stdout.
#######################################
has() {
  helpin "${@}" || exit 1
  which "${1}" 1>/dev/null 2>&1
}

####################################### ✓ hasc: exported function
# Check if executable, function or alias exists (command -v)
# Arguments:
#   -h, --help          Show help message and exit.
#   command             Command to check.
# Returns:
#   1 if does not exists.
# Output:
#   Help message to stdout.
#######################################
hasc() {
  helpin "${@}" || exit 1
  command -v "${1}" 1>/dev/null 2>&1
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

####################################### ✓ inf: exported function
# Show info message with > symbol in grey bold
# Globals:
#   GreyDim            Grey dimmed color for info message and > symbol.
#   Reset              Reset color.
# Arguments:
#   -h, --help         Show help message and exit.
#   Message            Message to show in grey bold with > symbol.
# Output:
#   Message to stdout or help message.
# Returns:
#   1 if -h or --help and not  man page.
#######################################
inf() {
  helpin "${@}" || exit 1
  printf '%b\n' "${GreyDim}> $*${Reset}"
}

####################################### ✓ isroot: exported function
# Is root (id -u is 0)?
# Arguments:
#   -h, --help            Show help message and exit.
# Output:
#   Help message to stdout.
# Returns:
#   1 if no root and -h or --help and not man page.
#######################################
isroot() {
  helpin "${@}" || exit 1
  [ "$(id -u)" -eq 0 ]
}

####################################### ✓ issudo: exported function
# Is sudo (SUDO_UID is set)?
# Arguments:
#   -h, --help            Show help message and exit.
# Output:
#   Help message to stdout.
# Returns:
#   1 if no 'SUDO_UID' and -h or --help and not man page.
#######################################
issudo() {
  helpin "${@}" || exit 1
  [ "${SUDO_UID-}" ]
}

####################################### ✓ isuser: exported function
# Is user (not root and not sudo)?
# Arguments:
#   -h, --help            Show help message and exit.
# Output:
#   Help message to stdout.
# Returns:
#   1 if no root and not sudo and -h or --help and not man page
#######################################
isuser() {
  helpin "${@}" || exit 1
  ! isroot "" && ! issudo ""
}

####################################### ✓ ok: exported function
# Show ok message in white with green ✓ symbol
# Globals:
#   Green              Green color for ✓ symbol.
#   Reset              Reset color.
# Arguments:
#   -h, --help         Show help message and exit.
#   Message            Message to show in white with green ✓ symbol.
# Output:
#   Message or help message to stdout.
#######################################
ok() {
  helpin "${@}" || exit 1
  printf '%b\n' "${Green}✓${Reset} $*"
}

####################################### ✓ pscmd: exported function
# Parent process cmd (cmd/command part of ps) if in a subshell or cmd of the current shell if running in a subshell.
# $$ is defined to return the process ID of the parent in a subshell; from the man page under "Special Parameters":
# expands to the process ID of the shell. In a () subshell, it expands to the process ID of the current shell,
# not the subshell.
# Arguments:
#   -h, --help            Show help message and exit.
# Outputs:
#   Process (ps) cmd.
# Returns:
#   1 if error during installation of procps or not know to install ps  or -h or --help and not man page.
# ######################################
pscmd() {
  helpin "${@}" || exit 1
  if has ps; then
    if [ "${DARWIN-}" ]; then
      ps -p$$ -ocommand=
    elif [ "${ALPINE-}" ] && [ "${BUSYBOX-}" ]; then
      ps -o pid= -o comm= | awk '/$$/ { $1=$1 };1' | grep "^$$ " | awk '{ print $2 }'
    else
      ps -p$$ -ocmd=
    fi
  else
    if [ "${DEBIAN-}" ] || [ "${FEDORA-}" ] ; then
      ${PM_INSTALL} procps || die 1 "procps: could not be installed"
      ps -p$$ -ocmd=
    else
      die 1 "ps: do not know how to install"
    fi
  fi
}

####################################### ✓ real: exported function
# Absolute logical (symlink) or resolved (physical) path (if does not exists, accepts one level up to cd).
# Arguments:
#   -h, --help            Show help message and exit.
#   path                  Path (default: cwd).
# Output:
#   Path or help message to stdout.
# Returns:
#   1 if parent directory does not exists or -h or --help and not man page.
#######################################
real() {
  helpin "${@}" || exit 1
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

####################################### ✓ shell: exported function
# Which shell has sourced me?.
# Global vars
#   IS_BASH              true if has been sourced in BASH.
#   IS_BSH               true if has been sourced in BASH or SH.
#   IS_DASH              true if has been sourced in DASH.
#   IS_FISH              true if has been sourced in FISH.
#   IS_KSH               true if has been sourced in KSH.
#   IS_SH                true if has been sourced in SH.
#   IS_ZSH               true if has been sourced in ZSH.
# Arguments:
#   -h, --help            Show help message and exit.
# Output:
#   Help message to stdout.
# Returns:
#   1 if -h or --help and not not man page.
#######################################
shell() {
  helpin "${@}" || exit 1
  export IS_BASH=false IS_BSH=false IS_DASH=false IS_FISH=false IS_KSH=false IS_SH=false IS_XONSH=false IS_ZSH=false
  sh="${0##*/}"
  if [ "${sh}" = "sh" ]; then
    export IS_SH=true IS_BSH=true
  elif [ -n "${BASH_VERSION}" ]; then
    export IS_BASH=true IS_BSH=true
  elif [ -n "${ZSH_EVAL_CONTEXT}" ]; then
    export IS_ZSH=true
  elif [ -n "${KSH_VERSION}" ]; then
    export IS_KSH=true
  elif [ "${sh}" = "dash" ]; then
    export IS_DASH=true
  elif [ "${XONSH_VERSION-}" ]; then
    export IS_XONSH=true
  else
    unset sh
    exit
  fi
  unset sh
}

####################################### x vars: unset function
# Sets OS globals (this function is unset)
# Global vars
#   ALPINE               "1" if 'DIST_ID' is "alpine".
#   ALPINE_LIKE          "1" if 'DIST_ID' is "alpine".
#   ARCHLINUX            "1" if 'DIST_ID' is "arch".
#   BASE_PATH            Base image directory path if 'IS_CONTAINER'.
#   BUSYBOX              "1" if not "/etc/os-release" and not "/sbin".
#   CENTOS               "1" if 'DIST_ID' is "centos".
#   DARWIN               "1" if 'UNAME' is "darwin".
#   DEBIAN               "1" if 'DIST_ID' is "debian".
#   DEBIAN_LIKE          "1" if "DIST_ID_LIKE is "debian".
#   DEBIAN_FRONTEND      "noninteractive" if 'IS_CONTAINER' and 'DEBIAN_LIKE' are set.
#   DIST_CODENAME        "Catalina", "Big Sur", "kali-rolling", "focal", etc.
#   DIST_ID              <alpine|centos|debian|kali|macOS|ubuntu>.
#   DIST_ID_LIKE         <alpine|debian|rhel fedora>.
#   DIST_VERSION         macOS <10.15.1|10.16|...>, kali <2021.2|...>, ubuntu <20.04|...>.
#   ENV                  Shell profile/rc start file (for 'ALPINE_LIKE').
#   FEDORA               "1" if 'DIST_ID' is "fedora".
#   IS_CONTAINER         "1" if running in docker container.
#   FEDORA_LIKE          "1" if 'DIST_ID' is "fedora" or "fedora" in "DIST_ID_LIKE".
#   KALI                 "1" if 'DIST_ID' is "kali".
#   MACOS                true if 'UNAME' is "darwin", else false.
#   NIXOS                "1" if 'DIST_ID' is "alpine" and "/etc/nix".
#   PM                   Package manager (apk, apt, brew, nix or yum) for 'DIST_ID'.
#   PM_INSTALL           Package manager install command with options quiet.
#   RHEL                 "1" if 'DIST_ID' is "rhel".
#   RHEL_LIKE            "1" if 'DIST_ID' is "rhel" or "rhel" in "DIST_ID_LIKE".
#   UBUNTU               "1" if 'DIST_ID' is "ubuntu".
#   UNAME                "linux" or "darwin".
# Arguments:
#   None
vars() {
  { [ -f /proc/1/environ ] || [ -f /.dockerenv ]; } && export IS_CONTAINER="1"


  ####################################### OS
  #
  export DIST_CODENAME DIST_ID DIST_ID_LIKE DIST_VERSION MACOS=false PM UNAME
  UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
  if [ "${UNAME}" = "darwin" ]; then
    export MACOS=true
    export DARWIN="1"
    DIST_ID="$(sw_vers -ProductName)"
    DIST_VERSION="$(sw_vers -ProductVersion)"
    case "$(echo "${DIST_VERSION}" | awk -F. '{ print $1 $2 }')" in
      1013) DIST_CODENAME="High Sierra" ;;
      1014) DIST_CODENAME="Mojave" ;;
      1015) DIST_CODENAME="Catalina" ;;
      11*) DIST_CODENAME="Big Sur" ;;
      12*) DIST_CODENAME="Monterey" ;;
      *) DIST_CODENAME="Other" ;;
    esac
    eval "$(/usr/libexec/path_helper -s)"
    if CLT="$(xcode-select --print-path 2>/dev/null)"; then
      PATH="${PATH}:${CLT}"
    fi
    PM="brew"
  else
    _file="/etc/os-release"
    if test -f "${_file}"; then
      while IFS="=" read -r _var _value; do
        # shellcheck disable=SC2154
        case "${_var}" in
          ID)
            DIST_ID="${_value}"
            case "${DIST_ID}" in
              alpine)
                export ALPINE="1" ALPINE_LIKE="1" DIST_ID_LIKE="${DIST_ID}" PM="apk"
                [ -r "/etc/nix" ] && export NIXOS="1" PM="nix"
                ;;
              arch) export ARCHLINUX="1" PM="pacman" ;;
              centos) export CENTOS="1" PM="yum" ;;
              debian) export DEBIAN="1" DEBIAN_LIKE="1" DIST_ID_LIKE="${DIST_ID}" ;;
              fedora) export FEDORA="1" FEDORA_LIKE="1" PM="dnf" ;;
              kali) export KALI="1" ;;
              rhel) export RHEL="1" RHEL_LIKE="1" PM="yum";;
              ubuntu) export UBUNTU="1" ;;
              *) export DIST_UNKNOWN="1" ;;
            esac
            ;;
          ID_LIKE)
            DIST_ID_LIKE="${_value}"
            case "${DIST_ID_LIKE}" in
              debian)
                export DEBIAN_LIKE="1" PM="apt"
                [ "${IS_CONTAINER-}" ] && export DEBIAN_FRONTEND="noninteractive"
                ;;
              *fedora*) export FEDORA_LIKE="1" ;;
              *rhel*) export RHEL_LIKE="1" ;;
            esac
            ;;
          VERSION_ID) DIST_VERSION="${_value}" ;;
          VERSION_CODENAME) DIST_CODENAME="${_value}" ;;
        esac
      done < "${_file}"
      unset _var _value
    else
      [ -d "/sbin" ] && export BUSYBOX="1"
      unset DIST_CODENAME DIST_ID DIST_ID_LIKE DIST_VERSION PM
      return 2>/dev/null || exit
    fi
    unset _file
  fi

  ####################################### BASE_PATH, IS_CONTAINER, PM and PM_INSTALL
  #
  case "${PM}" in
    apk) _install="add -q --no-progress" _nocache="--no-cache" ;;
    apt) _install="install -y -qq" ;;
    brew) _install="install --quiet" ;;
    dnf) _install="install -y -q" ;;
    nix) _install="nix-env --install -A" ;; # nixos -> nixos.curl, no nixos --> nixpkgs.curl
    pacman) _install="-S --noconfirm" ;;
    yum) _install="install -y -q" ;;
  esac
  export PM_INSTALL="${PM} ${_install}"
  if [ "${IS_CONTAINER-}" ]; then
    export BASE_PATH="/base"
    PATH="${BASE_PATH}:${PATH}"
    PM_INSTALL="${PM_INSTALL} ${_nocache}"
  fi
  unset _install _nocache
}

####################################### ✓ warn - exported function
# Show warning message with ! symbol in yellow
# Globals:
#   Yellow             Yellow color for warning message and ! symbol.
#   Reset              Reset color.
# Arguments:
#   -h, --help         Show help message and exit.
#   Message            Message to show in yellow with ! symbol.
# Output:
#   Message to stderr or help message to stdout.
# Returns:
#   1 if -h or --help and not not man page.
#######################################
# shellcheck disable=SC3044
warn() {
  helpin "${@}" || exit 1
  if hasc caller; then
    c="$(caller 0)"
    if [ "$(echo "${c}" | awk '{ print $2 }')" = "die" ]; then c="$(caller 1)"; fi
    add="${YellowDim}$(basename "$(echo "${c}" | awk '{ print $3 }')")[$(echo "${c}" | awk '{ print $1 }')]${Reset} "
  fi
  printf '%b\n' "${Yellow}x${Reset} ${add}${Yellow}$*${Reset}" >&2
  unset add c
}

###################################### > functions: run
# run functions
######################################
for i in color constants shell vars; do
  ${i}
done

###################################### > functions: export
# export functions
######################################
for i in die err has hasc helpin inf isroot issudo isuser ok pscmd real ret root shell warn; do
  if ! $IS_DASH || ! $IS_KSH; then
    continue
  else
    # shellcheck disable=SC3045
    export -f "${i?}" 2>/dev/null || true
  fi
done

###################################### > functions: unset
# export functions
######################################
for i in color constants vars; do
  unset -f "${i}"
done; unset i
