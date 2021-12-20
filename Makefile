.PHONY: chmod clean tests verbose

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := $(DIR).envrc

chmod:
	@for i in $${RC_PREFIX}/bin $${RC_PREFIX}/sbin; do chmod +x $${TOP}/$${i}/* 2>/dev/null || true; done

clean:
	@rm -rf $${TESTS}/output; rm -rf $${RC_D_TEST_SHARE}

env:
	@echo RC_PREFIX: $${RC_PREFIX}

tests: clean chmod env
	@bats $${TESTS} --jobs $${TESTS_JOBS} --print-output-on-failure --recursive

verbose: clean chmod env
	@bats $${TESTS} --gather-test-outputs-in $${TESTS}/output --jobs $${TESTS_JOBS} --no-tempdir-cleanup \
--output $${TESTS}/output --print-output-on-failure --recursive --show-output-of-passing-tests --timing \
--trace --verbose-run

