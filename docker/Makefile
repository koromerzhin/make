LAMPY_NAME := lampy

USER := $(shell id -u)
GROUP := $(shell id -g)

DOCKER_LAUNCH := USER_ID=$(USER) GROUP_ID=$(GROUP) docker

DOCKER_EXEC := $(DOCKER_LAUNCH) exec -i -u root
DOCKER_EXECTTY := $(DOCKER_LAUNCH) exec -ti -u root

DOCKER_SUPPORTED_COMMANDS := update inspect ssh logs docker lampy
DOCKER_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(DOCKER_SUPPORTED_COMMANDS))
ifneq "$(DOCKER_SUPPORTS_MAKE_ARGS)" ""
  DOCKER_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(DOCKER_ARGS):;@:)
endif

.PHONY: isdocker
isdocker: ## Docker is launch ?
ifeq ($(shell docker info > /dev/null 2>&1 && echo 1), 0)
	@echo "Docker is not launch"
	exit 1
endif

.PHONY: lampy
lampy: isdocker ### Lampy install
	@cd lampy && make docker swarm-init
	@cd lampy && make docker create-network
	@cd lampy && make docker image-pull
	@cd lampy && make docker deploy
	@cd lampy && make sleep 60
	@cd lampy && make docker ls

define Docker_create_network
	docker network create --driver=overlay $(1);
endef

define Docker_stack_container
	@$(DOCKER_LAUNCH) stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "${NEED}" $$i $$i; done
endef

.PHONY: docker
docker: isdocker ### Scripts docker
ifeq ($(DOCKER_ARGS),images)
	@$(DOCKER_LAUNCH) images
else ifeq ($(DOCKER_ARGS),swarm-init)
	@$(DOCKER_LAUNCH) swarm init --default-addr-pool 10.20.0.0/16
else ifeq ($(DOCKER_ARGS),login)
	@$(DOCKER_LAUNCH) login
else ifeq ($(DOCKER_ARGS),create-network)
	@$(foreach network,${NETWORK},$(call Docker_create_network,$(network)))
else ifeq ($(DOCKER_ARGS),image-pull)
	@more docker-compose.yml | grep image: | sed -e "s/^.*image:[[:space:]]//" | while read i; do docker pull $$i -q; done
else ifeq ($(DOCKER_ARGS),deploy)
	@$(DOCKER_LAUNCH) stack deploy -c docker-compose.yml $(STACK)
else ifeq ($(DOCKER_ARGS),ls)
	@$(DOCKER_LAUNCH) stack services $(STACK)
else ifeq ($(DOCKER_ARGS),stop)
	@$(DOCKER_LAUNCH) stack rm $(STACK)
else
	@printf "${MISSING_ARGUMENTS}" docker
	$(call array_arguments, \
		["create-network"]="create network" \
		["deploy"]="deploy" \
		["image-pull"]="Get docker image" \
		["images"]="images" \
		["login"]="login" \
		["ls"]="docker service" \
		["stop"]="docker stop" \
		["swarm-init"]="swarm init" \
	)
endif

.PHONY: logs
logs: isdocker ### Scripts logs
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" logs
	$(call Docker_stack_container)
else
	@$(DOCKER_LAUNCH) service logs -f --tail 100 --raw $(STACK)_$(DOCKER_ARGS).1.$$(docker service ps -f 'name=$(STACK)_$(DOCKER_ARGS)' $(STACK)_$(DOCKER_ARGS) -q --no-trunc | head -n1)
endif

.PHONY: ssh
ssh: isdocker ### SSH
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" ssh
	$(call Docker_stack_container)
else
	@$(DOCKER_EXECTTY) $(STACK)_$(DOCKER_ARGS).1.$$(docker service ps -f 'name=$(STACK)_$(DOCKER_ARGS)' $(STACK)_$(DOCKER_ARGS) -q --no-trunc | head -n1) bash
endif

.PHONY: inspect
inspect: isdocker ### docker service inspect
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" inspect
	$(call Docker_stack_container)
else
	@$(DOCKER_LAUNCH) service inspect $(STACK)_$(DOCKER_ARGS)
endif

.PHONY: update
update: isdocker ### docker service update
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" update
	$(call Docker_stack_container)
else
	@$(DOCKER_LAUNCH) service update $(STACK)_$(DOCKER_ARGS)
endif