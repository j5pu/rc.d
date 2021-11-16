#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

# shellcheck disable=SC2016
test-shell() {
  bash -c '. profile.d/00.sh && $IS_BASH && $IS_BSH'
  bash -c '. profile.d/00.sh && $IS_SH && $IS_BSH' || true
  bash -c '. profile.d/00.sh && $IS_ZSH' || true
  dash -c '. profile.d/00.sh && $IS_DASH'
  dash -c '. profile.d/00.sh && $IS_BASH' || true
  ksh -c '. profile.d/00.sh && $IS_KSH'
  ksh -c '. profile.d/00.sh && $IS_BASH' || true
  sh -c '. profile.d/00.sh && $IS_SH && $IS_BSH'
  sh -c '. profile.d/00.sh && $IS_BASH && $IS_BSH' || true
  sh -c '. profile.d/00.sh && $IS_ZSH' || true
  zsh -c '. profile.d/00.sh && $IS_ZSH'
  zsh -c '. profile.d/00.sh && $IS_BSH' || true
  zsh -c '. profile.d/00.sh && $IS_SH' || true
}

test-shell
