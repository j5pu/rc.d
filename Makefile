.PHONY: chmod tests

DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)/bin:$(DIR)/lib:$(PATH)

back:
	@sudo cp /etc/profile~bk /etc/profile

chmod:
	@for i in bin hooks lib tests; do chmod +x ./$${i}/* 2>/dev/null || true; done

rc.d:
	@sudo rm -rf /etc/rc.d && sudo cp -rf $(DIR)etc/profile $(DIR)etc/rc.d /etc && . /etc/profile a

tests: chmod
	@for i in ./tests/test-*.sh; do $${i}; done
