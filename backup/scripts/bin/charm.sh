#!/bin/sh
#
# PyCharm LightEdit (nohup).
# https://www.jetbrains.com/help/pycharm/working-with-the-ide-features-from-command-line.html
exec 1>>"${LOGS}/$(basename "${0}").log"
exec 2>&1

echo
echo "${@}"
nohup ltedit.sh "${@}"
