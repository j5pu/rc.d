
.PHONY: chmod tests

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)bin:$(DIR)sbin:$(PATH)


chmod:
	@for i in bin sbin; do chmod +x ./$${i}/* 2>/dev/null || true; done

tests: chmod
	# bats tests --gather-test-outputs-in tests/output --no-tempdir-cleanup --output tests/output \
# --print-output-on-failure --recursive --timing --trace --verbose-run
	bats tests --gather-test-outputs-in tests/output --no-tempdir-cleanup --output tests/output \
--print-output-on-failure --recursive --timing --trace --verbose-run
