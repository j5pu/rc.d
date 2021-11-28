.PHONY: chmod tests

DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)/bin:$(DIR)/lib:$(PATH)

back:
	@sudo cp /etc/profile.orig /etc/profile; sudo rm -rf /etc/rc.d

chmod:
	@for i in bin hooks lib tests; do chmod +x ./$${i}/* 2>/dev/null || true; done

rc.d:
	@sudo cp $(DIR)helpers/profile.test /etc/profile
	@rm -rf /tmp/opt && mkdir /tmp/opt && cp -rf $(DIR) /tmp/opt
	@. /etc/profile --force

tests: chmod
	@for i in ./tests/test-*.sh; do $${i}; done
