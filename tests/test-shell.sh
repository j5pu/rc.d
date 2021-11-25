#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

# shellcheck disable=SC2016
test-shell() {
  bash -c '. bin/shell.lib && shell && $IS_BASH && $IS_BSH'
  bash -c '. bin/shell.lib && shell && $IS_SH && $IS_BSH' || true
  bash -c '. bin/shell.lib && shell && $IS_ZSH' || true
  dash -c '. bin/shell.lib && shell && $IS_DASH'
  dash -c '. bin/shell.lib && shell && $IS_BASH' || true
  ksh -c '. bin/shell.lib && shell && $IS_KSH'
  ksh -c '. bin/shell.lib && shell && $IS_BASH' || true
  sh -c '. bin/shell.lib && shell && $IS_SH && $IS_BSH'
  sh -c '. bin/shell.lib && shell && $IS_BASH && $IS_BSH' || true
  sh -c '. bin/shell.lib && shell && $IS_ZSH' || true
  zsh -c '. bin/shell.lib && shell && $IS_ZSH'
  zsh -c '. bin/shell.lib && shell && $IS_BSH' || true
  zsh -c '. bin/shell.lib && shell && $IS_SH' || true
}

test-shell
