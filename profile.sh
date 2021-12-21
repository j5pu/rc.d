#!/bin/sh
# shellcheck disable=SC1090

# System profile
#
umask 0002
export PATH='/usr/sbin:/usr/bin:/sbin:/bin'

# <html><h2>RC Name</h2>
# <p><strong><code>$RC_NAME</code></strong> contains the rc directory name.</p>
# </html>
export RC_NAME='rc.d'
# <html><h2>RC Prefix when Installed</h2>
# <p><strong><code>$RC_D</code></strong> contains the rc prefix to install or to be installed.</p>
# </html>
export RC_D="/etc/${RC_NAME}"
# <html><h2>RC Running in Installed Prefix</h2>
# <p><strong><code>$RC_INSTALLED</code></strong> 1 if shell is running under an installed version.</p>
# </html>
export RC_INSTALLED="${RC_PREFIX:-1}"
# Input for profile.sh library: directories and files
#
# <html><h2>RC Repository Top Path</h2>
# <p><strong><code>$RC_RC_PREFIX</code></strong> contains the git top path.</p>
# </html>
export RC_PREFIX="${RC_PREFIX:-${RC_D}}"
# <html><h2>Source after Update RC Share and Generated libraries</h2>
# <p><strong><code>$RC_PROFILE</code></strong> set to 1 to update all rc libraries.</p>
# <p>It's set to 1 and exported for the first login shell, to caching the rc.d libraries.</p>
# <h3>Examples</h3>
# <dl>
# <dt>In a library to source withouth sourcing:</dt>
# <dd>
# <pre><code class="language-bash">if ! command -v assert >/dev/null || [ &quot;${RC_PROFILE-0}&quot; -eq 1 ]; then
# &emsp; do something
# &emsp; . generated
# else
# &emsp; . generated
# fi
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>To update then, sourcing system profile:</dt>
# <dd>
# <pre><code class="language-bash">RC_PROFILE=0 . /etc/profile
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>To update them, running profile:</dt>
# <dd>
# <pre><code class="language-bash">rc --force
# </code></pre>
# </dd>
# </dl>
# </html>
export RC_PROFILE="${RC_PROFILE:-0}"

if [ "${RC_PROFILE}" -eq 0 ]; then
  [ "${DIST_ID-}" ] || . "${RC_PREFIX}/lib/system.sh"
  for script in "${RC_PREFIX}"/profile.d/*; do [ -f "${script}" ] && . "${script}"; done
  RC_PROFILE=1
fi
