
.PHONY: clean chmod env tests verbose

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export BASH_ENV := $(DIR).envrc

clean:
	@rm -rf $${TESTS}/output; rm -rf $${RC_D_TEST_SHARE}

chmod:
	@for i in $${TOP}/bin $${TOP}/sbin; do chmod +x $${TOP}/$${i}/* 2>/dev/null || true; done

env:
	@. bats.lib && echo BATS_DOCKER: $${BATS_DOCKER}
	@echo BATS_JOBS: $${BATS_JOBS}
	@echo MANPATH: $${MANPATH}
	@echo RC_D_TEST_SHARE: $${RC_D_TEST_SHARE}
	@echo PATH: $${PATH}
	@echo TESTS: $${TESTS}
	@echo TOP: $${TOP}

tests: clean chmod
	@. bats.lib && bats $${TESTS} --jobs $${BATS_JOBS} --print-output-on-failure --recursive

verbose: clean chmod
	@. bats.lib && bats $${TESTS} --gather-test-outputs-in $${TESTS}/output --jobs $${BATS_JOBS} --no-tempdir-cleanup \
--output $${TESTS}/output --print-output-on-failure --recursive --show-output-of-passing-tests --timing \
--trace --verbose-run
