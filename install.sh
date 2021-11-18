#!/bin/sh
set -e

# TODO: las funciones de curl o wget en funcion del sistema
# TODO: ver que hago si tengo python o si hago un rc install para los míos y upgrade.

self=false
[ "${SELFINSTALL-}" ] && self=true && git all && curl -fsSL "https://git.io/rc.d" | sh -s "${SELFINSTALL_ARGS}"

clear
printf '\n'

f="00.sh"
directory="$( cd "$(dirname "${0}")" || exit 1; pwd)"
p="${directory}/profile.d/${f}"
ok=false

{ [ -r "${p}" ] || ! $self; } || { p="/tmp/${f}"; rm -f "${p}"; curl -fsSL "https://git.io/${f}" -o "${p}"; ok=true; }
. "${p}"

$ok && info "${f}" downloaded
info "${f}" sourced
