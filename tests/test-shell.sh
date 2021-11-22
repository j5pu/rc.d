#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

# shellcheck disable=SC2016
test-shell() {
  bash -c '. lib/shell.lib && shell && $IS_BASH && $IS_BSH'
  bash -c '. lib/shell.lib && shell && $IS_SH && $IS_BSH' || true
  bash -c '. lib/shell.lib && shell && $IS_ZSH' || true
  dash -c '. lib/shell.lib && shell && $IS_DASH'
  dash -c '. lib/shell.lib && shell && $IS_BASH' || true
  ksh -c '. lib/shell.lib && shell && $IS_KSH'
  ksh -c '. lib/shell.lib && shell && $IS_BASH' || true
  sh -c '. lib/shell.lib && shell && $IS_SH && $IS_BSH'
  sh -c '. lib/shell.lib && shell && $IS_BASH && $IS_BSH' || true
  sh -c '. lib/shell.lib && shell && $IS_ZSH' || true
  zsh -c '. lib/shell.lib && shell && $IS_ZSH'
  zsh -c '. lib/shell.lib && shell && $IS_BSH' || true
  zsh -c '. lib/shell.lib && shell && $IS_SH' || true
}

test-shell
