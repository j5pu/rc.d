#!/usr/bin/env bash
#
# System/sudo password
echo "${__PASSWORD:-${PASSWORD}}"
unset __PASSWORD
