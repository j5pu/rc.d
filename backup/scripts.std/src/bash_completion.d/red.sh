#!/usr/bin/env bash

_red() {
  local cur options other
  cur=${COMP_WORDS[COMP_CWORD]}
  >&2 echo "COMP_CWORD: ${COMP_CWORD} "
  >&2 printf '%s\n' "${COMP_WORDS[@]}"
  options=( -h --help -n )
  case "${cur}" in
      -h|--help) return ;;
      *)
        # COMP_WORDS not in options
        other="$(sort <(printf '%s\n' "${COMP_WORDS[@]}") <(printf '%s\n' "${options[@]}") | uniq -u )"
        >&2 printf '%s\n' "${COMP_WORDS[@]}"
        >&2 echo "other: ${other}"
        # check if -h or --help in previous first and return
        # el 0 tiene el nombre del programa
        mapfile -t COMPREPLY < <(compgen -W "${other}" -- "${cur}") ;;
  esac
}
# intersection
#sort <(ls one) <(ls two) | uniq -d
# symmetric difference of two lists
#sort <(ls one) <(ls two) | uniq -u

complete -F _red red.sh
