.DEFAULT_GOAL := help

GENERAL_SUPPORTED_COMMANDS := contributors sleep
GENERAL_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(GENERAL_SUPPORTED_COMMANDS))
ifneq "$(GENERAL_SUPPORTS_MAKE_ARGS)" ""
  GENERAL_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(GENERAL_ARGS):;@:)
endif

.PHONY: sleep
sleep: ## sleep *
	@sleep  $(GENERAL_ARGS)

node_modules:
	@npm install

.PHONY: contributors
contributors: node_modules ## Contributors *
ifeq ($(GENERAL_ARGS),add)
	@npm run contributors add
else ifeq ($(GENERAL_ARGS),check)
	@npm run contributors check
else ifeq ($(GENERAL_ARGS),generate)
	@npm run contributors generate
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make git ARGUMENT"
	@echo "---"
	@echo "add: ADD"
	@echo "check: CHECK"
	@echo "generate: GENERATE"
endif

.PHONY: git
check: node_modules ## check
	@make contributors check -i
	@make linter all -i
	@git status

.PHONY: help
help:
	@echo "* : arguments nécéssaire"
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e "s/^.*Makefile://" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
