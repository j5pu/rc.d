# shellcheck shell=sh disable=SC2034

# '1' if 'DIST_ID' is 'alpine'
export ALPINE

# '1' if 'DIST_ID' is 'alpine'
export ALPINE_LIKE

# '1' if 'DIST_ID' is 'arch'
export ARCHLINUX

# '1' if not '/etc/os-release' and not '/sbin'
export BUSYBOX

# '1' if 'DIST_ID' is 'centos'.
export CENTOS

# '1' if running in docker container.
export CONTAINER

# '1' if 'DIST_ID' is 'debian'.
export DEBIAN

# '1' if 'DIST_ID_LIKE is 'debian'.
export DEBIAN_LIKE

# 'noninteractive' if 'IS_CONTAINER' and 'DEBIAN_LIKE' are set.
export DEBIAN_FRONTEND

# <alpine|debian|rhel fedora>.
export DIST_ID_LIKE

# '1' if 'DIST_ID' is 'fedora'.
export FEDORA

# '1' if 'DIST_ID' is 'fedora' or 'fedora' in 'DIST_ID_LIKE'.
export FEDORA_LIKE

# Version of formula, $HOMEBREW_PREFIX/opt is a symlink to $HOMEBREW_CELLAR (brew shellenv)
export HOMEBREW_CELLAR

# Brew bash completion (bash_completion.d) compat directory $BASH_COMPLETION_COMPAT_DIR, under etc
export HOMEBREW_COMPLETION

# Homebrew etc
export HOMEBREW_ETC

# Symlink for the latest version of formula to $HOMEBREW_CELLAR
export HOMEBREW_OPT

# Homebrew prefix (brew shellenv)
export HOMEBREW_PREFIX

# Profile compat dir (profile.d), under etc.
export HOMEBREW_PROFILE

# Repository and Library with homebrew gems and Taps (brew shellenv)
export HOMEBREW_REPOSITORY

# Taps path under '$HOMEBREW_REPOSITORY/Library'
export HOMEBREW_TAPS

# <html><h2>Distribution Codename</h2>
# <p><strong><code>$DIST_CODENAME</code></strong> (always exported).</p>
# <ul>
# <li><code>Catalina</code></li>
# <li><code>Big Sur</code></li>
# <li><code>kali-rolling</code></li>
# <li><code>focal</code></li>
# <li><code>etc.</code></li>
# </ul>
# </html>
export DIST_CODENAME

# <html><h2>Distribution ID</h2>
# <p><strong><code>$DIST_ID</code></strong> (always exported).</p>
# <ul>
# <li><code>alpine</code></li>
# <li><code>centos</code></li>
# <li><code>debian</code></li>
# <li><code>kali</code></li>
# <li><code>macOS</code></li>
# <li><code>ubuntu</code></li>
# </ul>
# </html>
export DIST_ID

# <html><h2>Distribution Version</h2>
# <p><strong><code>$DIST_ID</code></strong> (always exported).</p>
# <ul>
# <li><code>macOS</code>: 10.15.1, 10.16 ...</li>
# <li><code>kali</code>: 2021.2, ...</li>
# <li><code>ubuntu</code> 20.04, ...</li>
# </ul>
# </html>
export DIST_VERSION

# <html><h2>First part of hostname</h2>
# <p><strong><code>$HOST</code></strong> (always exported).</p>
# <ul>
# <li><code>foo.com</code>: foo</li>
# <li><code>example.foo.com</code>: example</li>
# </ul>
# </html>
export HOST

# Symbol and 'HOST' if 'CONTAINER' or 'SSH'.
export HOST_PROMPT

# '1' if 'DIST_ID' is 'kali'.
export KALI

# <html><h2>Is MACOS?</h2>
# <p><strong><code>$MACOS</code></strong> (always exported).</p>
# <p><strong><code>Boolean</code></strong></p>
# <ul>
# <li><code>true</code>: $UNAME is darwin</li>
# <li><code>false</code>: $UNAME is linux</li>
# </ul>
# </html>
export MACOS

# '1' if 'DIST_ID' is 'alpine' and '/etc/nix'.
export NIXOS

# <html><h2>Default Package Manager</h2>
# <p><strong><code>$PM</code></strong> (always exported).</p>
# <ul>
# <li><code>apk</code></li>
# <li><code>apt</code></li>
# <li><code>brew</code></li>
# <li><code>nix</code></li>
# <li><code>yum</code></li>
# </ul>
# </html>
export PM

# <html><h2>Default Package Manager with Install Options</h2>
# <p><strong><code>$PM_INSTALL</code></strong> (always exported).</p>
# <p><strong><code>Quiet and no cache (for containers)</code></strong>.</p>
# <ul>
# <li><code>apk</code></li>
# <li><code>apt</code></li>
# <li><code>brew</code></li>
# <li><code>nix</code></li>
# <li><code>yum</code></li>
# </ul>
# </html>
export PM_INSTALL

# PyCharm repository, application executable and configuration full path.
export PYCHARM

# PyCharm contents (initial plugins, etc.).
export PYCHARM_CONTENTS

# '1' if 'DIST_ID' is 'rhel'.
export RHEL

# '1' if 'DIST_ID' is 'rhel' or 'rhel' in 'DIST_ID_LIKE'.
export RHEL_LIKE

# '1' if 'SSH_CLIENT' or 'SSH_TTY' or 'SSH_CONNECTION'.
export SSH

# '1' if 'DIST_ID' is 'ubuntu'.
export UBUNTU

# <html><h2>Operating System System Name</h2>
# <p><strong><code>$UNAME</code></strong> (always exported).</p>
# <ul>
# <li><code>darwin</code></li>
# <li><code>linux</code></li>
# </ul>
# </html>
export UNAME
