#!/usr/bin/env bash
#
# Install static launcher for bootstrap command

#######################################
# System bootstrap install
# Globals:
#   __EXECUTABLE   install path
#   __FORCE        force to overwrite executable
#   __NAME         name
#   _BTRAP_URL     githubusercontent url
main() {
  local sudo

  [[ ! "${__EXECUTABLE-}" ]] || return 1
  [[ ! "${__NAME-}" ]] || return 1
  [[ ! "${_BTRAP_URL-}" ]] || return 1

  sudo="$( command -v sudo )"

  if ! test -x "${__EXECUTABLE}" || [[ "${__FORCE-}" ]]; then
    if [[ ! "${__DRY_RUN-}" ]]; then
      if ${sudo} tee "${__EXECUTABLE}" >/dev/null <<'EOT'
#!/usr/bin/env bash
curl -fsSL https://git.io/btrap | bash -s "${@}"
EOT
      then
        ${sudo} chmod +x "${__EXECUTABLE}"
      else
        false
      fi
    else
      true
    fi
  fi
}
main
