# shellcheck shell=sh

{ [ "${__PROFILE_SOURCE_IT-}" ] || [ "${PS1-}" ]; } || { return 0 2>/dev/null || exit 0; }

# TODO: aqui lo dejo acabar con el prompt,
# TODO: quitar el history de jedi pycharm
export PROMPT_COMMAND="history -a;history -r"
export PS2="${BlueDim}> "
export PS4="+ [${Magenta}\$(basename \"\${BASH_SOURCE[0]}\")${Reset}][${Magenta}\${LINENO}${Reset}]\
[${Yellow}\$(echo \${BASH_LINENO[*]} | awk '{\$NF=\"\"; print \$0}' | sed 's/ \$//g'| sed 's/ /@/g')${Reset}]\
${Green}$ ${Reset}"

if [ -f "${STARSHIP_CONFIG}" ]; then
    eval "$(starship init bash)"
else
  if is user; then
    if $MACOS || [ "${PROMPT_SSH_THE_SAME-}" ]; then
      PS1="\[\e]0;\h@\u: \w\a\]\"\$(err=\$?; if [ \${err} -eq 0 ]; then \$(printf '%b' ${Green}✓); else \
        \$(printf '%b' ${Red}\${err} x)\";fi) ${Reset}${Green}\h${Reset} ${Blue}\w${Reset} ${Green}\$${Reset} "
    else
      PS1="\[\e]0;\h@\u: \w\a\]${Green}\h${Reset} ${Magenta}\u${Reset} ${Blue}\w${Reset} ${Green}\$${Reset} "
    fi
  else
    PS1="\[\e]0;\h@\u: \w\a\]${Red}\h${Reset} ${Blue}\w${Reset} ${Red}#${Reset} "
  fi
fi

[ "${SH-}" ] || unset -f starship_precmd
