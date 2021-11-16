#!/usr/bin/env bash
set -e

cd "$(dirname "${0}")/.." || exit 1

test-shell() {
  bash -c '. lib/shell.lib && $IS_BASH && $IS_BSH'
  bash -c '. lib/shell.lib && $IS_SH && $IS_BSH' || true
  bash -c '. lib/shell.lib && $IS_ZSH' || true
  sh -c '. lib/shell.lib && $IS_SH && $IS_BSH'
  sh -c '. lib/shell.lib && $IS_BASH && $IS_BSH' || true
  sh -c '. lib/shell.lib && $IS_ZSH' || true
  zsh -c '. lib/shell.lib && $IS_ZSH'
  zsh -c '. lib/shell.lib && $IS_BSH' || true
  zsh -c '. lib/shell.lib && $IS_SH' || true
}


test-shell
