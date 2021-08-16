.DEFAULT_GOAL := help

COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

.PHONY: sleep
sleep: ## sleep *
	@sleep  $(COMMAND_ARGS)

node_modules:
	@npm install

.PHONY: contributors
contributors: node_modules ## Contributors *
ifeq ($(COMMAND_ARGS),add)
	@npm run contributors add
else ifeq ($(COMMAND_ARGS),check)
	@npm run contributors check
else ifeq ($(COMMAND_ARGS),generate)
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

.PHONY: help
help:
	@echo "* : arguments nécéssaire"
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e "s/^.*Makefile://" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
