# shellcheck shell=sh

# TODO: mover fichero y que cuando se hace un install hay que hacer rebash a

###################################### DOCKER
# https://docs.docker.com/develop/develop-images/build_enhancements/#to-enable-buildkit-builds
# https://docs.docker.com/engine/reference/commandline/cli/
if has docker; then
  # DOCKER_BUILDKIT:       If set, enables building images with BuildKit. performance, storage management,
  #                        feature functionality, and security.
  # https://docs.docker.com/buildx/working-with-buildx/
  # Docker Buildx is included in Docker Desktop and Docker Linux packages when installed using the DEB or RPM packages.
  # --platform (for example, linux/amd64, linux/arm64, or darwin/amd64).
  # You can also download the latest buildx binary from the Docker buildx releases page on GitHub,
  # copy it to ~/.docker/cli-plugins folder with name docker-buildx and change the permission to execute:
  export DOCKER_BUILDKIT=1
  # https://docs.docker.com/engine/reference/commandline/cli/#experimental-features
  export DOCKER_CLI_EXPERIMENTAL='enabled'
  # DOCKER_CONFIG         The location of your client configuration files.
  export DOCKER_CONFIG="${ETC}/docker"
fi

###################################### GCC
#
if has gcc >/dev/null; then
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi

###################################### GH
# https://cli.github.com/manual/gh_help_environment
if has gh; then
  # GH_CONFIG_DIR:                               Directory where gh will store configuration files.
  #                                              Default: '$XDG_CONFIG_HOME/gh' or "$HOME/.config/gh".
  export GH_CONFIG_DIR="${ETC}/gh"
  # GH_HOST                                     GitHub hostname for commands that would otherwise assume the
  #                                              'github.com' host when not in a context of an existing repository.
  export GH_HOST='github.com'
  # GLAMOUR_STYLE                               Style to use for rendering Markdown.
  export GLAMOUR_STYLE='dark'
fi

####################################### GOOGLE CLOUD CONFIG
# https://cloud.google.com/compute/docs/gcloud-compute
# https://cloud.google.com/sdk/gcloud/reference/config
# CLOUDSDK_<SECTION>_<PROPERTY>:
if has gcloud; then
  # CLOUDSDK_CONFIG.                             Google Cloud config directory.
  export CLOUDSDK_CONFIG="${ETC}/gcloud"
  # CLOUDSDK_CORE_PROJECT                       Google Cloud SDK core project.
  export CLOUDSDK_CORE_PROJECT='jose-lumenbiomics'
  # CLOUDSDK_COMPUTE_REGION                     Google Cloud compute region.
  export CLOUDSDK_COMPUTE_REGION='EUROPE-WEST1'
  # CLOUDSDK_COMPUTE_ZONE                       Google Cloud compute zone..
  export CLOUDSDK_COMPUTE_ZONE='EUROPE-WEST1-B'
fi

###################################### GIT
# https://git-scm.com/docs/git-config
# https://git-scm.com/docs/git-init
# GIT_COMPLETION_SHOW_ALL                     Show --arguments in completions.
if has git; then
  export GIT_PAGER='less'
  export GIT_COMPLETION_SHOW_ALL
  export GIT_CONFIG_SYSTEM="${ETC}/git/gitconfig"
  export GIT_TEMPLATE_DIR="${ETC}/git/templates"
fi

# ###################################### GITHUB
#
# GIT                                         GitHub user login.
export GIT='j5pu'
# GIT_BRANCH                                  Default branch
export GIT_BRANCH='main'
# GIT_EMAIL                                   GitHub private email with user GitHub ID.
export GIT_EMAIL="63794670+${GIT}@users.noreply.github.com"
# GIT_ID                                      GitHub ID.
export GIT_ID='4379404'
# GIT_ORG                                     GitHub organization.
export GIT_ORG='lumenbiomics'
# GIT_REMOTE                                  Default remote
export GIT_REMOTE='origin'
# GIT_RAW                                     GitHub user content raw up to user in path,
#                                             repo/branch/file should be added.
export GIT_RAW="https://raw.githubusercontent.com/${GIT}"

###################################### HOMEBREW
# https://docs.brew.sh/Manpage#bundle-subcommand
if has brew; then
  # HOMEBREW_BAT                                If set, use bat for the brew cat command.
  export HOMEBREW_BAT=1
  # HOMEBREW_CLEANUP_PERIODIC_FULL_DAY          If set, brew install, brew upgrade and brew reinstall will cleanup all
  #                                             formulae when this number of days has passed.
  export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=7
  # HOMEBREW_COLOR                              If set, force colour output on non-TTY outputs.
  export HOMEBREW_COLOR=1
  # HOMEBREW_NO_ANALYTICS                       If set, do not send analytics. For more information.
  export HOMEBREW_NO_ANALYTICS=1
  # HOMEBREW_UPDATE_REPORT_ONLY_INSTALLED       If set, brew update only lists updates to installed software.
  export HOMEBREW_UPDATE_REPORT_ONLY_INSTALLED=1
fi

###################################### LESS & PAGER
#
has less && export LESS='-F -R -X' PAGER='less'

###################################### MANPAGER
#
has most && export MANPAGER='most'

###################################### PIP
# https://pip.pypa.io/en/stable/topics/configuration/
# PIP_<UPPER_LONG_COMMAND_LINE_OPTION_NAME>  Dashes (-) have to be replaced with underscores (_).
if has pip >/dev/null 2>/dev/null; then
  export PIP_CONFIG_FILE="${ETC}/pip/pip.conf"
  # PIP_DISABLE_PIP_VERSION_CHECK             If set, don’t periodically check PyPI to determine whether
  #                                            a new version of pip is available for download.
  export PIP_DISABLE_PIP_VERSION_CHECK=1
fi

###################################### PYTHON
# https://docs.python.org/3/using/cmdline.html
if has python >/dev/null 2>/dev/null; then
  # PYTHON_REQUIRES                             Projects global setting for minimum python version,
  #                                             unless specified in project setup.cfg.
  export PYTHON_VERSION='3.9'
  # PYTHONASYNCIODEBUG                          If this environment variable is set to a non-empty string,
  #                                             enable the debug mode of the asyncio module.
  #
  export PYTHONASYNCIODEBUG=0
  # PYTHONDONTWRITEBYTECODE                     If set, python won’t try to write .pyc files on the import of source
  #                                             modules. This is equivalent to specifying the -B option.
  export PYTHONDONTWRITEBYTECODE=1
  # PYTHONNOUSERSITE                            If this is set, Python won’t add the user site-packages
  #                                             directory to sys.path.
  export PYTHONNOUSERSITE=0
  # PYTHONUNBUFFERED                            If this is set to a non-empty string it is equivalent
  #                                             to specifying the -u option.
  export PYTHONUNBUFFERED=1
fi

###################################### STARSHIP
# https://starship.rs/config/#prompt
# Test in /opt/etc but always update with 'rc config starship'
if has -c starship; then
  # TODO: aqui no porque no se hace con comando de setup
  #   Can be tested in /opt/etc like starship but always backup
  #  to the repo and run `rc config --upgrade`
  export STARSHIP_CONFIG="${ETC}/starship/config.toml"
fi

###################################### VI
#
if has vi; then
  export EDITOR='vi'
  export VISUAL="${EDITOR}"
fi

###################################### STDLIB
#
export CLICOLOR=1
export CLICOLOR_FORCE=1
# FIGNORE                                     A colon-separated list of suffixes to ignore when performing filename
#                                             completion. A filename whose suffix matches one of the
#                                             entries in 'FIGNORE' is excluded from the list of matched
#                                             filenames.  A sample value is '.o:~
export FIGNORE='.o:~:Application Scripts'
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
# HISTSIZE                                    Equivalent to 'set history-size' maximum number of history entries
export HISTSIZE=999999
export HISTFILESIZE=999999
# INPUTRC                                     Inputrc file to use, $include /etc/inputrc can be added to the inputrc to
#                                             include another file.
export INPUTRC="${ETC}/inputrc"
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export PROMPT_COMMAND='history -a;history -r'
export PS2="${BlueDim}> "
export PS4="+ [${Magenta}\$(basename \"\${BASH_SOURCE[0]}\")${Reset}][${Magenta}\${LINENO}${Reset}]\
[${Yellow}\$(echo \${BASH_LINENO[*]} | awk '{\$NF=\"\"; print \$0}' | sed 's/ \$//g'| sed 's/ /@/g')${Reset}]\
${Green}$ ${Reset}"
export TERM='xterm-256color'

if $MACOS; then
  ###################################### STDLIB
  #
  # BASH_SILENCE_DEPRECATION_WARNING            If set suppress macOS bash deprecation warning.
  export BASH_SILENCE_DEPRECATION_WARNING=1
  # LSCOLORS                                    macOS
  export LSCOLORS='ExGxBxDxCxEgEdxbxgxcxd'

  ###################################### USER
  #
  if is root; then
    # CDPATH                                      Once the CDPATH is set, the cd command will search only
    #                                             in the directories present in the CDPATH variable only.
    #                                             It SHOULD always be the first component of the CDPATH.
    unset CDPATH
    export CDPATH="${CDPATH}:${HOME}/GitHub"
    # LIBRARY
    export LIBRARY="${HOME}/Library"
    # MOBILE
    export MOBILE="${HOME}/Library/Mobile Documents"
    # TEXTEDIT                                    Secrets ssh directory
    export TEXTEDIT="${HOME}/Library/Mobile Documents/com~apple~TextEdit/Documents"
  fi
fi
