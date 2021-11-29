# shellcheck shell=sh

# TODO: aqui lo dejo acabar con el prompt,
# TODO: quitar el history de jedi pycharm

if [ -f "${STARSHIP_CONFIG}" ]; then
    eval "$(starship init bash)"
else
  PROMPT_COMMAND="prompt;${PROMPT_COMMAND}"
fi

[ "${SH-}" ] || unset -f starship_precmd
