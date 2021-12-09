# shellcheck shell=sh disable=SC2034

# <html><h2>Force Updating Shared Libraries</h2>
# <p><strong><code>$FORCE</code></strong> (Default: unset).</p>
# <h3>Examples</h3>
# <dl>
# <dt>For all shared libraries:</dt>
# <dd>
# <pre><code class="language-bash">FORCE=1 . profile.lib
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>From a shared library:</dt>
# <dd>
# <pre><code class="language-bash">FORCE=1 . os.lib
# FORCE=1 . color.lib
# </code></pre>
# </dd>
# </dl>
# </html>
declare FORCE
