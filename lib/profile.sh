# shellcheck shell=sh

# System profile.
#

unset ENV

# <html><h2>Force removal of rc.d library files and sourcing files</h2>
# <p><strong><code>$PROFILE</code></strong> set to 0 to update all rc libraries.</p>
# <h3>Examples</h3>
# <dl>
# <dt>To update then, sourcing system profile:</dt>
# <dd>
# <pre><code class="language-bash">PROFILE=0 . /etc/profile
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>To update them, running profile.lib:</dt>
# <dd>
# <pre><code class="language-bash">profile.lib --force
# </code></pre>
# </dd>
# </dl>
# </html>
PROFILE="${PROFILE:-0}"
if test "${PROFILE}" -eq 0; then
  export RC_D
# <html><h2>Source Development Library</h2>
# <p><strong><code>$DEV</code></strong> when is 1 sources dev.lib and change directory of generated libraries.</p>
# </html>
  DEV="${DEV:-0}"; export DEV
  eval "$(colon rcenv)"

  . ../bin/system.lib
  . ../bin/dev.lib

  PROFILE=1
fi

ENV="$(command -v profile.lib || echo /etc/profile)"

####################################### PS1
# Moved here since needed by sudo because it's not exported and needed by sudoers shell_noargs ('sudo -S').
# BASH_ENV/ENV will trigger the assignment.
#if [ "${PS1-}" ]; then
#    export Reset='\033[0m'
#    PS1="\[\e]0;\h@\u: \w\a\]${Reset}"
#fi

####################################### Executed: force & parse
#
if echo "$0" | grep -q 'profile.lib$'; then
  if test "$#" -ne 0 && test "${1-}" = '--parsed' && shift; then
    case "$1" in
      --force) shift; PROFILE=0 . profile.lib
    esac
  elif test "$#" -ne 0; then
    . ../bin/helpers.lib
    PARSE="$0" parse "$@"
  fi
fi
