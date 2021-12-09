# shellcheck shell=sh disable=SC2034

# <html><h2>Show Debug Messages</h2>
# <p><strong><code>$DEBUG</code></strong> (Default: unset).</p>
# <p><strong><code>Debug messages are not shown if unset.</code></strong></p>
# <p>Activate with either of:</p>
# <ul>
# <li><code>DEBUG=1</code></li>
# <li><code>--debug</code></li>
# </ul>
# </html>
declare DEBUG

# <html><h2>Function one line Description</h2>
# <p><strong><code>$DESC</code></strong> contains the function description, for scripts is automatically extracted.</p>
# <p>Use <strong>$DESC</strong> to call `parse` from a function so it is shown when --desc argument is used.</p>
# <h3>Examples</h3>
# <dl>
# <dt>From a function:</dt>
# <dd>
# <pre><code class="language-bash">DESC='description'
# [ &quot;${PARSED-}&quot; ] || PARSE='function' parse &quot;${@:-}&quot;
# </code></pre>
# </dd>
# </dl>
# </html>
declare DESC

# <html><h2>Bash Strict Mode</h2>
# <p><strong><code>$STRICT</code></strong> Set to 1 when sourcing helpers.lib to source strict.lib (Default: unset).</p>
# <h3>Links</h3>
# <ul>
# <li><a href="http://redsymbol.net/articles/unofficial-bash-strict-mode/">Unofficial Bash Strict Mode</a></li>
# </ul>
# </html>
declare STRICT

# <html><h2>Dry Run</h2>
# <p><strong><code>$DRYRUN</code></strong> (Default: unset).</p>
# <p>Activate with either of:</p>
# <ul>
# <li><code>DRYRUN=1</code></li>
# <li><code>--dryrun</code></li>
# </ul>
# </html>
declare DRYRUN

# <html><h2>Function Name or Full Script Path to Parse Arguments</h2>
# <p><strong><code>$PARSE</code></strong> contains the function name or script path ($0).</p>
# <p>Use <strong>$PARSE</strong> to call `parse` from a function or script in posix.</p>
# <p>If not set and BASH_VERSION, the following are used: </p>
# <ul>
# <li><code>FUNCNAME[1]: if BASH_SOURCE[1] =~ *.lib</code></li>
# <li><code>BASH_SOURCE[1]: if BASH_SOURCE[1] != *.lib</code></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>From a function:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# else
# &emsp;DESC='description' PARSE='function' parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>From a script in sh:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# &emsp; unset PARSED
# else
# &emsp;PARSE=&quot;${0}&quot; parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>From a script in bash:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# &emsp; unset PARSED
# else
# &emsp;parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# </html>
declare PARSE

# <html><h2>Arguments Parsed</h2>
# <p><strong><code>$PARSED</code></strong> will be set when arguments have been parsed to avoid recursion.</p>
# <p>Check if <strong>$PARSE</strong> is set before calling `parse` from a function or script.</p>
# <h3>Examples</h3>
# <dl>
# <dt>From a function:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# else
# &emsp;DESC='description' PARSE='function' parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>From a script in sh:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# else
# &emsp;PARSE=&quot;${0}&quot; parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# <dl>
# <dt>From a script in bash:</dt>
# <dd>
# <pre><code class="language-bash">if [ &quot;${PARSED-}&quot; ] && unset PARSED; then
# &emsp;for arg do; case &quot;${arg}&quot; in --other-option) echo &quot;${arg}&quot; ;; esac; done
# else
# &emsp;parse &quot;${@:-}&quot;
# fi
# </code></pre>
# </dd>
# </dl>
# </html>
#export PARSED
declare PARSED

# <html><h2>Silent Output</h2>
# <p><strong><code>$QUIET</code></strong> (Default: unset).</p>
# <p><strong><code>The following messages are shown if unset:</code></strong></p>
# <ul>
# <li><code>error</code></li>
# <li><code>ok</code></li>
# </ul>
# <p><strong><code>If unset, other messages are shown base on the variable value:</code></strong></p>
# <ul>
# <li><code>debug</code>: $DEBUG</li>
# <li><code>verbose</code>: $VERBOSE</li>
# <li><code>warning</code>: $WARNING</li>
# </ul>
# <p>Activate with either of:</p>
# <ul>
# <li><code>QUIET=1</code></li>
# <li><code>--quiet</code></li>
# </ul>
# <p><strong><code>Note:</code></strong></p>
# <p>Takes precedence over $DEBUG, $VERBOSE and $WARNING.</p>
# </html>
declare QUIET

# <html><h2>Show Verbose Messages</h2>
# <p><strong><code>$VERBOSE</code></strong>  (Default: unset).</p>
# <p><strong><code>Verbose messages are not shown if unset.</code></strong></p>
# <p>Activate with either of:</p>
# <ul>
# <li><code>VERBOSE=1</code></li>
# <li><code>--verbose</code></li>
# </ul>
# </html>
declare VERBOSE

# <html><h2>Show Warning Messages</h2>
# <p><strong><code>$WARNING</code></strong>  (Default: unset).</p>
# <p><strong><code>Warning messages are not shown if unset</code></strong></p>
# <p>Activate with either of:</p>
# <ul>
# <li><code>WARNING=1</code></li>
# <li><code>--warning</code></li>
# </ul>
# </html>
declare WARNING
