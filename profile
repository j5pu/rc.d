#!/bin/sh

# System profile
#
export RC_NAME='rc.d'
export RC_D="/etc/${RC_NAME}"
export RC_PREFIX="${RC_PREFIX:-${RC_D}}"
export RC_GENERATED="${RC_PREFIX}/generated.d"
export RC_PASSWORD_FILE="${RC_GENERATED}/password.sh"

[ "${RC_PROFILE-0}" = 1 ] || "${RC_PREFIX}/bin/rc --force"
[ "${UNAME-}" ] || for generated in "${RC_GENERATED}"/*; do . "${generated}"; done
export RC_PROFILE=1
