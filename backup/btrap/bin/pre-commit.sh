#!/usr/bin/env bash

cmd() {
  echo "curl -fsSL \"${RAW}/${repo}/${branch}/${1}\" | bash -s"
}

branch="$( git remote-branch-default )"
commands_d="commands.d"
defaults_d="defaults.d"
directory="$( pwd )"
info_commands="info/commands.csv"
info_completion="info/completion.text"
info_defaults="info/defaults.text"
repo="${directory##*/}"

chmod -x bash_completion.d/*
chmod -R +x bin
chmod -x "${commands_d}"/*
chmod -x "${defaults_d}"/*
chmod +x "${repo}"

for i in info_commands info_completion info_defaults; do
  printf '' > "${!i}"
done

for relative in "${commands_d}"/??-*.sh; do
  base=$( basename "${relative}" .sh )
  name="$( awk -F '-' '{ print $2 }' <<< "${base}" )"
  value="$( awk -F '-' '{ print $3 }' <<< "${base}" )"
  help="$( awk -F '^# ' '/^# [A-Z]/ { print $2; exit }' "${relative}" )"
  option="--${name}"
  echo "${option},$( cmd "${relative}" ),${help},${value}" >> "${info_commands}"
  printf '%s ' "${option}" >> "${info_completion}"
done

echo -n "--dry-run --trace --help -h" >> "${info_completion}"

for relative in "${defaults_d}"/*.sh; do
  cmd "${relative}" >> "${info_defaults}"
done
