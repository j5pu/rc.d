
.PHONY: clean chmod tests verbose

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)bin:$(DIR)sbin:$(PATH)
OUTPUT := $(DIR)tests/output
FIXTURES := $(DIR)tests/fixtures
FIXTURES_RC_D := $(DIR)tests/fixtures/rc_d_test

clean:
	@rm -rf $(OUTPUT); rm -rf $(FIXTURES_RC_D)/share

chmod:
	@for i in bin sbin; do chmod +x $(DIR)$${i}/* 2>/dev/null || true; done

tests: clean chmod
	@bats $(DIR)tests --print-output-on-failure --recursive --tap

verbose: clean chmod
	@bats $(DIR)tests --gather-test-outputs-in $(OUTPUT) --no-tempdir-cleanup --output $(OUTPUT) \
--print-output-on-failure --recursive --show-output-of-passing-tests --timing --trace --verbose-run
