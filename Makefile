SHELL = /bin/bash
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

.DEFAULT_GOAL = help

# $(eval $(call helps,COMMAND,MESSAGES)
# Add help describe COMMAND.
# If you want to insert a line break in MESSAGES,
# separate it with two character strings enclosed in double quotes.
#
# eg. $(eval $(call helps,command,"line1" "" "" "line2"))
#
#     It is displayed as follows:
#
#         command   : line1
#                     line2
#
define helps
  .PHONY: $(1).help help.$(1)
  $(1).help: help.$(1)
  help.$(1):
	@printf "$(indent)%-10s%1.1s %s\n" $1 : $2
endef
# COMMAND list for help and adding to phony target.
cmds =

# ................................................................
cmds += syncinit
syncinit:
	pipenv --python 3.8
	pipenv run python -m pip install --upgrade pip
	pipenv sync --dev
$(eval $(call helps,syncinit,\
	"Reproduce the environment using pipenv sync."))
# ................................................................
cmds += check
check:
	@echo "# flake8 #########################################"
	-@pipenv run flake8 .
	@echo "# mypy ###########################################"
	-@pipenv run mypy .
.check_help="Check format pep8 format by flake8, and type check by mypy."
$(eval $(call helps,check,$(.check_help)))
# ................................................................
cmds += format
format:
	pipenv run black .
$(eval $(call helps,format,"Corde formating by black."))
# ................................................................
cmds += test
test:
	@echo "# test ###########################################"
	pipenv run nosetests -v
$(eval $(call helps,test,"Run unit test."))
# ................................................................
.PHONY: help $(cmds)
help:
	@echo
	@echo "The following commands are supported this Makefile:"
	@echo
	@$(foreach x,$(cmds),$(MAKE) -s $(x).help indent="\t";)
	@echo
