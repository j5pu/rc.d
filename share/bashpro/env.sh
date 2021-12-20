# shellcheck shell=sh disable=SC2034

# Input for profile.sh library: directories and files
#

# <html><h2>RC Prefix when Installed</h2>
# <p><strong><code>$RC_D</code></strong> contains the rc prefix to install or to be installed.</p>
# </html>
export RC_D

# <html><h2>RC Running in Installed Prefix</h2>
# <p><strong><code>$RC_INSTALLED</code></strong> 1 if shell is running under an installed version.</p>
# </html>
declare RC_INSTALLED

# <html><h2>RC Name</h2>
# <p><strong><code>$RC_NAME</code></strong> contains the rc directory name.</p>
# </html>
export RC_NAME

# Input for profile.sh library: directories and files
#
# <html><h2>RC Repository Top Path</h2>
# <p><strong><code>$RC_RC_PREFIX</code></strong> contains the git top path.</p>
# </html>
export RC_PREFIX

# <html><h2>Generated rc.d Shell Libraries</h2>
# <p><strong><code>$RC_GENERATED</code></strong> contains the directory to store auto generated libraries.</p>
# </html>
export RC_GENERATED

# <html><h2>RC Bash Completions Compat Directory</h2>
# <p><strong><code>$RC_COMPLETION</code></strong> contains the path of bash completions.</p>
# </html>
export RC_COMPLETION

# <html><h2>User System Login Password</h2>
# <p><strong><code>$PASSWORD</code></strong> contains the User System Login Password.</p>
# <h3>Examples</h3>
# <dl>
# <dt>To update it, sourcing system profile:</dt>
# <dd>
# <pre><code class="language-bash">RC_FORCE=1 PASSWORD='new' . /etc/profile
# </code></pre>
# </dd>
# </dl>
# <dt>To update it, running profile.lib:</dt>
# <dd>
# <pre><code class="language-bash">PASSWORD='new' profile.lib --force
# </code></pre>
# </dd>
# </dl>
# </html>
export RC_PASSWORD_FILE

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
declare RC_PROFILE

# <html><h2>Operating System System Name</h2>
# <p><strong><code>$UNAME</code></strong> (always exported).</p>
# <ul>
# <li><code>Darwin</code></li>
# <li><code>Linux</code></li>
# </ul>
# </html>
export UNAME
