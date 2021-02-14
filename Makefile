SHELL = /bin/bash
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

.DEFAULT_GOAL = help

.DOCS = docs

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
  cmds += $(1)
  .PHONY: $(1).help help.$(1) $(1)
  $(1).help: help.$(1)
  help.$(1):
	@printf "$(indent)%-10s%1.1s %s\n" $1 : $2
endef

# ................................................................
.pipenvinit:
	pipenv --python 3.8
	pipenv run python -m pip install --upgrade pip
syncinit: .pipenvinit
	pipenv sync --dev
$(eval $(call helps,syncinit,\
	"Reproduce the environment by using \`pipenv sync'."))
# ................................................................
init: .pipenvinit
	pipenv install --dev --pre
$(eval $(call helps,init,\
	"Reproduce the environment by using \`pipenv install'."))
# ................................................................
check:
	@echo "# flake8 #########################################"
	-@pipenv run flake8 .
	@echo "# mypy ###########################################"
	-@pipenv run mypy .
.check_help="Check format pep8 format by flake8, and type check by mypy."
$(eval $(call helps,check,$(.check_help)))
# ................................................................
format:
	pipenv run isort .
	pipenv run black .
$(eval $(call helps,format,"Corde formating by black."))
# ................................................................
test:
	@echo "# test ###########################################"
	pipenv run nosetests -v
$(eval $(call helps,test,"Run unit test."))
# ................................................................
.module = `pipenv run python3 setup.py --name`
.author = `pipenv run python3 setup.py --author`
.pwd    != pwd
$(.DOCS):
	pipenv run sphinx-apidoc -F \
		--extensions sphinx.ext.napoleon \
		-A $(.author) -o $(.DOCS) $(.module)
	sed -i \
		-e "s|^# \(sys\.path.*\)'.*'\(.*\)|\1os.path.abspath(\"..\")\2|g" \
		-e "s@^# import \(os\|sys\)@import \1@g" \
		-e "s@^html_theme = 'alabaster'@html_theme = 'sphinx_rtd_theme'@g" \
		$(.DOCS)/conf.py

gendoc:| $(.DOCS)
	pipenv run sphinx-apidoc -f -o $(.DOCS) $(.module)
	pipenv run sphinx-build -a $(.DOCS) $(.DOCS)/_build
.gendoc_help="Generate or update document from pydoc by sphinx."
$(eval $(call helps,gendoc,$(.gendoc_help)))
# ................................................................
.PHONY: help
help:
	@echo
	@echo "The following commands are supported this Makefile:"
	@echo
	@$(foreach x,$(cmds),$(MAKE) -s $(x).help indent="\t";)
	@echo
