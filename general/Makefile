.DEFAULT_GOAL := help

GENERAL_SUPPORTED_COMMANDS := contributors sleep
GENERAL_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(GENERAL_SUPPORTED_COMMANDS))
ifneq "$(GENERAL_SUPPORTS_MAKE_ARGS)" ""
  GENERAL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(GENERAL_ARGS):;@:)
endif

GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
PURPLE := \033[0;35m
NC := \033[0m
NEED := ${GREEN}%-35s${NC}: %s\n
MISSING_ARGUMENTS :=${RED}ARGUMENT missing${NC}\n---\nmake ${PURPLE}%s${NC} ${YELLOW}ARGUMENT${NC}\n---\n

define array_arguments
	@declare -A PROVS=(${1})\
	; for key in "$${!PROVS[@]}" ; do \
		printf "${NEED}" $${key} "$${PROVS[$${key}]}"; \
    done
endef

.PHONY: sleep
sleep: ### sleep
	@sleep  $(GENERAL_ARGS)

node_modules:
	@npm install --legacy-peer-deps

.PHONY: contributors
contributors: node_modules ### Contributors
ifeq ($(GENERAL_ARGS),add)
	@npm run contributors add
else ifeq ($(GENERAL_ARGS),check)
	@npm run contributors check
else ifeq ($(GENERAL_ARGS),generate)
	@npm run contributors generate
else
	@printf "${MISSING_ARGUMENTS}" contributors
	$(call array_arguments, \
		["add"]="ADD" \
		["check"]="CHECK" \
		["generate"]="GENERATE" \
	)
endif

.PHONY: git
check: node_modules ## check
	@make contributors check -i
	@make linter all -i
	@git status

.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*? ## .*$$)|(^ ##)' $(MAKEFILE_LIST) | sed -e "s/^.*Makefile://" | awk 'BEGIN {FS = ":.*? ## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
	@printf "${YELLOW}commands with arguments${NC}\n"
	@grep -E '(^[a-zA-Z_-]+:.*? ### .*$$)|(^ ###)' $(MAKEFILE_LIST) | sed -e "s/^.*Makefile://" | awk 'BEGIN {FS = ":.*? ### "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'