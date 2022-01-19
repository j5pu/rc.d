.PHONY: chmod tests rc.d tests man info

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)bin:$(DIR)lib:$(PATH)

back:
	@sudo cp /etc/profile.orig /etc/profile; sudo rm -rf /etc/rc.d

rc.d:
	@sudo cp $(DIR)helpers/profile.test /etc/profile
	@rm -rf /tmp/opt && mkdir /tmp/opt && cp -rf $(DIR) /tmp/opt
	@. /etc/profile --force
