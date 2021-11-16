.PHONY: executables tests

executables:
	@chmod +x ./hooks/*
	@chmod +x ./lib/*.lib
	@chmod +x ./tests/*.sh
	@chmod +x ./install

tests: executables
	@for i in ./tests/test-*.sh; do $${i}; done
