#!/bin/sh
#
# PyCharm LightEdit (foreground).

exec 1>>"${LOGS}/$(basename "${0}").log"
exec 2>&1

echo
echo "${@}"
ltedit.sh "${@}"
