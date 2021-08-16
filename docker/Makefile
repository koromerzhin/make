.PHONY: isdocker
isdocker: ## Docker is launch ?
ifeq ($(shell docker info > /dev/null 2>&1 && echo 1), 0)
	@echo "Docker is not launch"
	exit 1
else
	@echo "Docker is launch"
endif

docker: isdocker ## Scripts docker *
ifeq ($(COMMAND_ARGS),create-network)
	@docker network create --driver=overlay $(NETWORK)
else ifeq ($(COMMAND_ARGS),image-pull)
	@more docker-compose.yml | grep image: | sed -e "s/^.*image:[[:space:]]//" | while read i; do docker pull $$i; done
else ifeq ($(COMMAND_ARGS),deploy)
	@docker stack deploy -c docker-compose.yml $(STACK)
else ifeq ($(COMMAND_ARGS),ls)
	@docker stack services $(STACK)
else ifeq ($(COMMAND_ARGS),stop)
	@docker stack rm $(STACK)
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make docker ARGUMENT"
	@echo "---"
	@echo "create-network: create network"
	@echo "image-pull: Get docker image"
	@echo "deploy: deploy"
	@echo "ls: docker service"
	@echo "stop: docker stop"
endif

.PHONY: logs
logs: isdocker ## Scripts logs *
ifeq ($(COMMAND_ARGS),)
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make logs ARGUMENT"
	@echo "---"
	@docker stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "\033[32m%-20s\033[0m %s\n" $$i $$i; done
else
	@docker service logs -f --tail 100 --raw $(STACK)_$(COMMAND_ARGS).1.$$(docker service ps -f 'name=$(STACK)_$(COMMAND_ARGS)' $(STACK)_$(COMMAND_ARGS) -q --no-trunc | head -n1)
endif

.PHONY: ssh
ssh: isdocker ## SSH *
ifeq ($(COMMAND_ARGS),)
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make ssh ARGUMENT"
	@echo "---"
	@docker stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "\033[32m%-20s\033[0m %s\n" $$i $$i; done
else
	@docker exec -it $(STACK)_$(COMMAND_ARGS).1.$$(docker service ps -f 'name=$(STACK)_$(COMMAND_ARGS)' $(STACK)_$(COMMAND_ARGS) -q --no-trunc | head -n1) sh
endif

.PHONY: inspect
inspect: isdocker ## docker service inspect *
ifeq ($(COMMAND_ARGS),)
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make inspect ARGUMENT"
	@echo "---"
	@docker stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "\033[32m%-20s\033[0m %s\n" $$i $$i; done
else
	@docker service inspect $(STACK)_$(COMMAND_ARGS)
endif

.PHONY: update
update: isdocker ## docker service update *
ifeq ($(COMMAND_ARGS),)
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make update ARGUMENT"
	@echo "---"
	@docker stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "\033[32m%-20s\033[0m %s\n" $$i $$i; done
else
	@docker service update $(STACK)_$(COMMAND_ARGS)
endif