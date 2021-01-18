SHELL = /bin/bash
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

.DEFAULT_GOAL = help

define helps
  .PHONY: $(1).help help.$(1)
  $(1).help: help.$(1)
  help.$(1):
	@printf "$(indent)%-10s: %s\n" $(1) $(2)
endef

# ................................................................
cmds += syncinit
syncinit:
	pipenv --python 3.8
	pipenv run python -m pip install --upgrade pip
	pipenv sync --dev
$(eval $(call helps,syncinit,\
	"Reproduce the environment using pipenv sync."))
# ................................................................
.PHONY: help $(cmds)
help:
	@echo
	@echo "The following commands are supported this Makefile:"
	@echo
	@$(foreach x,$(cmds),$(MAKE) -s $(x).help indent="\t";)
	@echo
