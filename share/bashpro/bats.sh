# shellcheck shell=sh disable=SC2034

# Current working directory
#
declare BATS_CWD

# Error status
#
declare BATS_ERROR_STATUS

# (default: bats) specifies the extension of test files that should be found when running a suite
# (via bats [-r] suite_folder/)
declare BATS_FILE_EXTENSION

# A temporary directory common to all tests of a test file.
# Could be used to create files required by multiple tests in the same test file
declare BATS_FILE_TMPDIR

# Library directory:
# Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core/libexec/bats-core
declare BATS_LIBEXEC

# <html><h2>Bats Libraries Repository Names (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_LIBS</code></strong>.</p>
# </html>
declare BATS_LIBS

# <html><h2>Bats Libraries Installation Paths (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_LIBS_DIRS</code></strong>.</p>
# </html>
declare BATS_LIBS_DIRS

# <html><h2>Bats Libraries Sample Functions to test Bats Libraries (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_LIBS_FUNCS</code></strong>.</p>
# </html>
declare BATS_LIBS_FUNCS

# Output file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-6576/bats.6612.out
declare BATS_OUT

# Name (not a file/file):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7204/bats.7229
declare BATS_PARENT_TMPNAME

# The repository of bats-core :
# /Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core
declare BATS_ROOT

# Command just run (everything but run until any pipe): run foo nofile would give 'foo nofile'
#
declare BATS_RUN_COMMAND

# The location to the temporary directory used by bats to store all its internal temporary files during the tests.
# (default: $BATS_TMPDIR/bats-run-$BATS_ROOT_PID-XXXXXX)
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7845
declare BATS_RUN_TMPDIR

# A temporary directory common to all tests of a suite. Could be used to create files required by multiple tests
#
declare BATS_SUITE_TMPDIR

# The (1-based) index of the current test case in the test suite (over all files)
#
declare BATS_SUITE_TEST_NUMBER

# <html><h2>Bats Test Filename Prefix (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TEST_PREFIX</code></strong> prefix of BATS_TEST_DIRNAME basename.</p>
# </html>
export BATS_TEST_PREFIX

# The description of the current test case.
#
declare BATS_TEST_DESCRIPTION

# The directory in which the Bats test file is located:
# /Applications/PyCharm.app/Contents/bin/scratches/bats-tests-vars
declare BATS_TEST_DIRNAME

# The fully expanded path to the Bats test file:
# /Applications/PyCharm.app/Contents/bin/scratches/bats-tests-vars/binman.bats
declare BATS_TEST_FILENAME

# The name of the function containing the current test case:
# /Applications/PyCharm.app/Contents/bin/scratches/bats-tests-vars/binman.bats
declare BATS_TEST_NAME

# An array of function names for each test case:
# /Applications/PyCharm.app/Contents/bin/scratches/bats-tests-vars
declare -a BATS_TEST_NAMES

# The (1-based) index of the current test case in the test file:
# 1
declare BATS_TEST_NUMBER

# Source file generated from the bats file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7632.src
declare BATS_TEST_SOURCE

# A a temporary directory unique for each test.
# Could be used to create files required only for specific tests
declare BATS_TEST_TMPDIR

# The location to a directory that may be used to store temporary files:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T
declare -x BATS_TMPDIR

# Temp file name under $BATS_RUN_TMPDIR (not created):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7642
declare BATS_TMPNAME

# <html><h2>Git Top Path (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TOP</code></strong> contains the git top directory when sourced from a git dir.</p>
# </html>
export BATS_TOP

# <html><h2>Git Top Basename (when sourcing: bats.lib)</h2>
# <p><strong><code>$BATS_TOP_NAME</code></strong> basename of git top directory when sourced from a git dir.</p>
# </html>
export BATS_TOP_NAME
