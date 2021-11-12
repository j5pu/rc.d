# System bootstrap


## Installing 🚀

```bash
curl -fsSL https://git.io/btrap | bash -s
```

```bash
_btrap()
{
    local cur prev before

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    before=${COMP_WORDS[COMP_CWORD-2]}
    if [ "${DEBUG-}" ]; then
      echo -e "\nCOMP_WORDS[@]: $( printf '%s,' "${COMP_WORDS[@]}" )"  >&2
      echo "len COMP_WORDS[@]: ${#COMP_WORDS[@]}"  >&2
      echo "COMP_LINE[@]: $( printf '%s,' "${COMP_LINE[@]}" )"  >&2
      echo "len COMP_LINE[@]: ${#COMP_LINE[@]}"  >&2
      echo "cur: ${cur}"  >&2
      echo "prev: ${prev}"  >&2
      echo "before: ${before}"  >&2
    fi

    case "${cur}" in
      -h|--help) return ;;
      --internet|--password) return ;;
      *)
        case "${before}" in
          --internet)
            if [ "${COMP_WORDS[COMP_CWORD-4]}" == "--password" ]; then
              return
            fi
            COMPREPLY=($(compgen -W "--password" -- ${cur})); return ;;
          --password)
            if [ "${COMP_WORDS[COMP_CWORD-4]}" == "--internet" ]; then
              return
            fi
            COMPREPLY=($(compgen -W "--internet" -- ${cur})); return ;;
        esac
        COMPREPLY=($(compgen -W "--internet --password -h --help" -- ${cur}))
       ;;
    esac
}
```
