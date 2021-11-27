# shellcheck shell=sh disable=SC2153


{ [ "${1-}" ] && [ "${1}" != "--force" ]; } && { return 1 2>/dev/null || exit 1; }

# TODO: mirar si funciona lo que cambie de profile

# __ETC_PROFILE_SOURCED   Has been sourced already for login shell.
# __PROFILE_SOURCE_IT     Force run when has not sourced yet or when "$1".
profile="${HOME}/.profile"
[ "${1}" = "--force" ] && { ; }
[ ! "${__ETC_PROFILE_SOURCED-}" ] && { export __ETC_PROFILE_SOURCED=1; __PROFILE_SOURCE_IT=1; }

if [ -f "${profile}" ]; then
  [ "${__PROFILE_SOURCE_IT-}" ] && . "${profile}"
else
  echo > "${HOME}/.hushlogin"
  ROOT="/opt"
  UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
  { [ "$(id -u)" -eq 0 ] && f="s"; } || s="s"
  export PATH="/usr/local/${f}bin:/usr/local/${s}bin:/usr/${f}bin:/usr/${s}bin:/${f}bin:/${s}bin"
  macos="false"
  if [ "${UNAME}" = "darwin" ]; then
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
    PM="brew"
    macos="true"
    PYCHARM_CONTENTS="/Applications/PyCharm.app/Contents"
    PYCHARM="${PYCHARM_CONTENTS}/bin"
    PATH="${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:${PATH}"
  else
    brew="/home/linuxbrew/.linuxbrew"
    PATH="${brew}/${s}bin:${brew}/${f}bin:${PATH}"
  fi

  tee "${profile}" > /dev/null <<EOF
# shellcheck shell=sh

#
# User generated profile

[ -n "\${__PROFILE_SOURCE_IT}" ] || { return 2>/dev/null || exit 0; }

####################################### Globals: MACOS and UNAME
# MACOS                 true if 'UNAME' is darwin.
# UNAME                 darwin or linux.
#
export MACOS=${macos}
export UNAME="${UNAME}"

####################################### Globals: ROOT
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# ROOT                  Root for project installations.
export ROOT="${ROOT}"
# BIN                   BIN.
export BIN="${ROOT}/bin"
# CONFIG                (USER) (SYNC - can be edited) Config directory, 'XDG_CONFIG_HOME' (/etc, ~/.config),
#                       can not be installed by command or change config directory via XDG_CONFIG_HOME.
#                       (USER) 'XDG_CONFIG_HOME': Base directory relative to which user-specific configuration files
#                       should be stored
export CONFIG="${ROOT}/config/${USER}"
export XDG_CONFIG_HOME="${ROOT}/config/${USER}"
# DOTFILES              (SYNC) Dotfiles repository to sync and to install when globals can not be used
#                       for ROOT directories.
export DOTFILES="${ROOT}/dotfiles"
# LIB                   Library directory.
export LIB="${ROOT}/lib"
# ETC                   Etc directory, installed with command (i.e.: 'rc config') or package.
export ETC="${ROOT}/etc"
# SBIN                  Executables and patched binaries directory to extend existing executables with the same name.
export SBIN="${ROOT}/bin"
# SHARE                 Share installation dir 'XDG_DATA_HOME' for libs & deps ("/usr/local/share", ~/.local/share).
#                       'XDG_DATA_HOME': Base directory relative to which user-specific data files should be stored.
#                       If 'XDG_DATA_HOME' is either not set or empty,
#                       a default equal to ~/.local/share should be used (system "/usr/local/share").
export SHARE="${ROOT}/share"
export XDG_DATA_HOME="${ROOT}/share"
# VAR                   Var directory (/var).
export VAR="${ROOT}/var"
EOF
  . "${profile}"

  tee -a "${profile}" > /dev/null <<EOF

####################################### Globals: ETC
# COMPLETION            Bash completion compat directory (/usr/local/etc/bash_completion.d, /etc/bash_completion).
export COMPLETION="${ETC}/bash_completion.d"
# PROFILE               Profile compat directory directory (/usr/local/etc/profile.d, /etc/profile.d).
export PROFILE="${ETC}/profile.d"
####################################### Globals: SHARE
# INFO                  Info pages directory (/usr/share/info).
export INFO="${SHARE}/info"
# MAN                   Man pages directory (/usr/share/man).
export MAN="${SHARE}/man"
# MAN1                  Man1 pages directory (/usr/share/man/man1).
export MAN1="${MAN}/man1"
####################################### Globals: VAR
# CACHE                 (USER) Cache directory 'XDG_CACHE_HOME' (/var/cache).
#                       (USER) 'XDG_CACHE_HOME': Base directory relative to which user-specific non-essential
#                       data files should be stored. If 'XDG_CACHE_HOME' is either not set or empty,
#                       a default equal to ~/.cache should be used.
export CACHE="${VAR}/cache/${USER}"
export XDG_CACHE_HOME="${VAR}/cache/${USER}"
# LOG                   (USER) Log directory (/var/log).
export LOG="${VAR}/log/${USER}"
# RUN                   (USER) Run directory 'XDG_RUNTIME_DIR' (/var/run).
# XDG_RUNTIME_DIR       (USER) 'XDG_RUNTIME_DIR': Base directory relative to which user-specific non-essential
#                       runtime files and other file objects (such as sockets, named pipes, ...) should be stored.
#                       The directory MUST be owned by the user, and he MUST be the only one having read and
#                       write access to it. Its Unix access mode MUST be 0700.
export RUN="${VAR}/run/${USER}"
export XDG_RUNTIME_DIR="${RUN}"

####################################### Globals: COLORS
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
# Contain the unicode Ansi escapes (\u001b) to be used in any language, e.g. Java, Python and Javascript).
# <Name>                 Color foreground.
# <Name>Bg               Color background.
# <Name>Bold             Color bold/bright.
# <Name>Dim              Color dimmed.
# <Name>Under            Color underscored.
# COLORS                 All color (Black Red Green Yellow Blue Magenta Cyan White) combinations.
# Reset                  Reset color.
# ######################################
EOF

  color() { [ "${colors-}" ] && sep=" "; colors="${colors}${sep}${1}"
    echo "export ${1}='\033[${2}${3}'" >> "${profile}"; unset sep; }
  color "Reset" 0 "m"
 export i=0
 for n in Black Red Green Yellow Blue Magenta Cyan Grey; do
    color "${n}" "3${i:-0}" "m"
    color "${n}Bold" "3${i}" ";1m"
    color "${n}Dim" "3${i}" ";2m"
    color "${n}Under" "3${i}" ";4m"
    color "${n}Invert" "3${i}" ";7m"
    color "${n}Bg" "4${i}" "m"
    export i="$((i+1))"
  done

  tee -a "${profile}" > /dev/null <<EOF
export COLORS="${colors}"

####################################### OS
# ALPINE               "1" if 'DIST_ID' is "alpine".
# ALPINE_LIKE          "1" if 'DIST_ID' is "alpine".
# ARCHLINUX            "1" if 'DIST_ID' is "arch".
# BUSYBOX              "1" if not "/etc/os-release" and not "/sbin".
# CENTOS               "1" if 'DIST_ID' is "centos".
# CONTAINER           "1" if running in docker container.
# DARWIN               "1" if 'UNAME' is "darwin".
# DEBIAN               "1" if 'DIST_ID' is "debian".
# DEBIAN_LIKE          "1" if "DIST_ID_LIKE is "debian".
# DEBIAN_FRONTEND      "noninteractive" if 'IS_CONTAINER' and 'DEBIAN_LIKE' are set.
# DIST_CODENAME        "Catalina", "Big Sur", "kali-rolling", "focal", etc.
# DIST_ID              <alpine|centos|debian|kali|macOS|ubuntu>.
# DIST_ID_LIKE         <alpine|debian|rhel fedora>.
# DIST_VERSION         macOS <10.15.1|10.16|...>, kali <2021.2|...>, ubuntu <20.04|...>.
# FEDORA               "1" if 'DIST_ID' is "fedora".
# FEDORA_LIKE          "1" if 'DIST_ID' is "fedora" or "fedora" in "DIST_ID_LIKE".
# KALI                 "1" if 'DIST_ID' is "kali".
# MACOS                true if 'UNAME' is "darwin", else false.
# NIXOS                "1" if 'DIST_ID' is "alpine" and "/etc/nix".
# PM                   Package manager (apk, apt, brew, nix or yum) for 'DIST_ID'.
# PM_INSTALL           Package manager install command with options quiet.
# RHEL                 "1" if 'DIST_ID' is "rhel".
# RHEL_LIKE            "1" if 'DIST_ID' is "rhel" or "rhel" in "DIST_ID_LIKE".
# UBUNTU               "1" if 'DIST_ID' is "ubuntu".
EOF
  if ! $MACOS; then
    file="/etc/os-release"
    if test -f "${f}"; then
      while IFS="=" read -r var value; do
        case "${var}" in
          ID)
            DIST_ID="${value}"
            case "${DIST_ID}" in
              alpine)
                {
                  echo "export ALPINE=1"
                  echo "export ALPINE_LIKE=1"
                  echo "export DIST_ID_LIKE=\"${DIST_ID}\""
                  if [ -r "/etc/nix" ]; then
                    echo "export NIXOS=1"
                    PM="nix-env"
                  else
                    PM="apk"
                  fi
                } >> "${profile}"
                ;;
              arch)
                echo "export ARCHLINUX=1" >> "${profile}"
                PM="pacman"
                ;;
              centos)
                echo "export CENTOS=1" >> "${profile}"
                PM="yum"
                ;;
              debian)
                {
                  echo "export DEBIAN=1"
                  echo "export DEBIAN_LIKE=1"
                  echo "export DIST_ID_LIKE=\"${DIST_ID}\""
                } >> "${profile}"
                ;;
              fedora)
                {
                  echo "export FEDORA=1"
                  echo "export FEDORA_LIKE=1"
                } >> "${profile}"
                PM="dnf"; export FEDORA_LIKE
                ;;
              kali) echo "export KALI=1" >> "${profile}" ;;
              rhel)
                {
                  echo "export RHEL=1"
                  echo "export RHEL_LIKE=1"
                } >> "${profile}"
                PM="yum"
                ;;
              ubuntu) echo "export UBUNTU=1" >> "${profile}" ;;
              *) echo "export DIST_UNKNOWN=1" >> "${profile}" ;;
            esac
            ;;
          ID_LIKE)
            DIST_ID="${value}"
            case "${DIST_ID}" in
              debian)
                echo "export DEBIAN_LIKE=1" >> "${profile}"
                PM="apt"
                ;;
              *fedora*) echo "export FEDORA_LIKE=1" >> "${profile}" ;;
              *rhel*) echo "export RHEL_LIKE=1" >> "${profile}" ;;
            esac
            ;;
          VERSION_ID) DIST_VERSION="${value}" ;;
          VERSION_CODENAME) DIST_CODENAME="${value}" ;;
        esac
      done < "${file}"
    else
      [ -d "/sbin" ] && echo "export BUSYBOX=1" >> "${profile}"
    fi
  fi
  case "${PM}" in
    apk) PM_INSTALL="add -q --no-progress"; no_cache="--no-cache" ;;
    apt) PM_INSTALL="install -y -qq" ;;
    brew) PM_INSTALL="install --quiet" ;;
    dnf) PM_INSTALL="install -y -q" ;;
    nix) PM_INSTALL="--install -A" ;; # nixos -> nixos.curl, no nixos --> nixpkgs.curl
    pacman) PM_INSTALL="-S --noconfirm" ;;
    yum) PM_INSTALL="install -y -q" ;;
  esac

  [ "${PM-}" ] && [ "${PM_INSTALL-}" ] && PM_INSTALL="${PM} ${PM_INSTALL}"
  if [ -f /proc/1/environ ] || [ -f /.dockerenv ]; then
    echo "export CONTAINER=1" >> "${profile}"
    [ "${DIST_ID}" = "debian" ] && echo "DEBIAN_FRONTEND=\"noninteractive\"" >> "${profile}"
    [ "${PM_INSTALL-}" ] && PM_INSTALL="${PM_INSTALL} ${n}"
  fi

  tee -a "${profile}" > /dev/null <<EOF
export DIST_CODENAME="${DIST_CODENAME}"
export DIST_ID="${DIST_ID}"
export DIST_VERSION="${DIST_VERSION}"
export PM="${PM}"
export PM_INSTALL="${PM_INSTALL}"
EOF

  $MACOS && tee -a "${profile}" >/dev/null <<EOF

####################################### PYCHARM
# PYCHARM_CONTENTS                            PyCharm contents (initial plugins, etc.).
export PYCHARM_CONTENTS="${PYCHARM_CONTENTS}"
# PYCHARM                                     PyCharm repository, application executable and configuration full path.
export PYCHARM="${PYCHARM_CONTENTS}/bin"
EOF
  if brew="$(brew --prefix 2>/dev/null)"; then
    ruby="$(brew --prefix ruby 2>/dev/null)" && PATH="${ruby}/bin:${ruby}/lib/ruby/gems/3.0.0/bin:${PATH}"
    brew_info="${brew}/share/info:"
    brew_man=":${brew}/share/man"
  fi

  tee -a "${profile}" >/dev/null <<EOF

####################################### INFOPATH, MANPATH & PATH
export INFOPATH="${INFO}:${brew_info}${INFOPATH:-}"
export MANPATH="${MAN}${brew_man}${MANPATH+:$MANPATH}:"
export PATH="${BIN}:${SBIN}:${LIB}/bash:${LIB}/sh:${PATH}"
EOF

  unset brew brew_info brew_man colors file i macos n no_cache ruby s var value
  unset -f color
  . "${profile}"
fi

unset profile
