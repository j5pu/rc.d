#!/bin/sh

#######################################
# Show message in red.
# Arguments:
#   1                 message to show
# Optional Arguments:
#   message            message to show
#   -h, --help         show help and exit
#   -n                 newline at the end
# Outputs:
#   Shows message to stdout.

first=false
message=""
name="$(basename "${0}" .sh)"
newline=false

for arg; do
  case "${arg}" in
    -h|--help)
      $( which man ) -p cat "$(basename "${0}" .sh)" 2>/dev/null
      exit
      ;;
    -n) newline=true ;;
    *)
      if $first; then
        printf '%s\n' "$(tput setaf 1)${name}$(tput sgr0)" "${message}" "${arg}"
      else
        message="${arg}"
        first=true
      fi
      ;;
  esac
  shift
done

if [ "${message-}" ]; then
  printf '%s' "$(tput setaf 1)${message}$(tput sgr0)"
  ! $newline || echo
fi
