.PHONY: chmod tests

chmod:
	@for i in bin hooks lib tests; do chmod +x ./$${i}/* 2>/dev/null || true; done

tests: chmod
	@for i in ./tests/test-*.sh; do $${i}; done
