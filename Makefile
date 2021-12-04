.PHONY: chmod tests rc.d tests man info

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)bin:$(DIR)lib:$(PATH)
MAN_SRC := $(DIR)etc/rc/src/man
MAN_DST := $(DIR)etc/rc/share/man/man1
INFO_DST := $(DIR)etc/rc/share/info
AUTHOR := $(shell git config user.username)
VERSION := $(shell source $(DIR)etc/profile --version)
DATE := $(shell date "+%Y-%M-%d")

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

man:
	@cd $(MAN_SRC); for i in *.adoc; do name=$$(basename $${i} .adoc); \
asciidoctor -b manpage -a doctitle="$${name^^}\(1)" -a author="$(AUTHOR)" -a release-version="$(VERSION)" \
-a manmanual="$${name^} Manual" -a mansource="$${name^} $(VERSION)" -a name="$${name}" -o \
$(MAN_DST)/$${name}.1 "$${i}"; \
done

	@cd $(MAN_SRC); for i in *.md; do \
name=$$(basename $${i} .md); \
pandoc $${i} -s -t man \
--metadata title="$${name^^}"  \
--metadata header="$${name^} Manual"  \
--metadata footer="$${name} $(VERSION)" \
--metadata date="$(DATE)" \
--metadata subtitle="$${name}"  \
--metadata author="$(AUTHOR)" \
-o $(MAN_DST)/$${name}.1 \
; done
	@cd $(MAN_SRC); for i in *.md; do \
name=$$(basename $${i} .md); \
pandoc $${i} -s -t texinfo \
--metadata title="$${name^^}"  \
--metadata header="$${name^} Manual"  \
--metadata footer="$${name} $(VERSION)" \
--metadata date="$(DATE)" \
--metadata subtitle="$${name}"  \
--metadata author="$(AUTHOR)" \
-o $(INFO_DST)/$${name}.info \
; done

