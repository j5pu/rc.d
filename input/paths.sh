# shellcheck shell=sh
# shellcheck disable=SC2034

# Input for rc env: RC_* and PATH variables
#
_fields=2
_darwin_clt='/Library/Developer/CommandLineTools/usr'
_linux_brew='/home/linuxbrew/.linuxbrew'

UNAME="$(command -p uname)"

_rc="$(command -p cat <<EOF
RC_COMPLETION='${PWD}/bash_completion.d'
RC_INSTALLED=$(if [ "${RC_D}" = "${RC_PREFIX}" ]; then true; else false; fi)
EOF
)"

_path="$(command -p cat <<EOF
${RC_PREFIX}/sbin;${UNAME}
${RC_PREFIX}/bin;${UNAME}
${RC_PREFIX}/lib;${UNAME}
${RC_D}/sbin;${UNAME}
${RC_D}/bin;${UNAME}
${RC_D}/lib;${UNAME}
/opt/sbin;${UNAME}
/opt/bin;${UNAME}
${_linux_brew}/sbin;Linux
${_linux_brew}/bin;Linux
/usr/local/sbin;${UNAME}
/usr/local/bin;${UNAME}
${_darwin_clt}/bin;Darwin
/usr/sbin;${UNAME}
/usr/bin;${UNAME}
/sbin;${UNAME}
/bin;${UNAME}
${PYCHARM:-};Darwin
${PYCHARM_CONTENTS:+${PYCHARM_CONTENTS:+/MacOS}};Darwin
$(command -p sed 's/$/;Darwin/g' /etc/paths.d/* | command -p uniq 2>/dev/null || echo ';')
EOF
)"


unset _darwin_clt _linux_brew
