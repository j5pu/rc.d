#!/bin/sh

# System profile
#
[ ! "${PS1-}" ] || set -eu
umask 0002

export RC_NAME='rc.d'
export RC_D="/etc/${RC_NAME}"
export RC_PREFIX="${RC_PREFIX:-${RC_D}}"
export RC_GENERATED="${RC_PREFIX}/generated.d"
export RC_GENERATED_ALIASES="${RC_PREFIX}/generated.d/alias.d"
export RC_PROFILE="${RC_PROFILE:-0}"

[ "${RC_PROFILE}" -eq 1 ] || "$("${RC_PREFIX}/bin/generated")"
[ "${UNAME-}" ] || for generated in "${RC_GENERATED}"/*; do . "${generated}"; done
export RC_PROFILE=1
