LAMPY_NAME := lampy

DOCKER_EXEC := docker exec -i
DOCKER_EXECTTY := docker exec -ti

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
	@cd lampy && make docker create-network
	@cd lampy && make docker image-pull
	@cd lampy && make docker deploy
	@cd lampy && make sleep 60
	@cd lampy && make docker ls

define Docker_create_network
	docker network create --driver=overlay $(1);
endef

define Docker_stack_container
	@docker stack services $(STACK) --format "{{.Name}}" | sed -e "s/^.*$(STACK)_//" | while read i; do printf "${NEED}" $$i $$i; done
endef

.PHONY: docker
docker: isdocker ### Scripts docker
ifeq ($(DOCKER_ARGS),images)
	@docker images
else ifeq ($(DOCKER_ARGS),swarm-init)
	@docker swarm init --default-addr-pool 10.20.0.0/16
else ifeq ($(DOCKER_ARGS),login)
	@docker login
else ifeq ($(DOCKER_ARGS),create-network)
	@$(foreach network,${NETWORK},$(call Docker_create_network,$(network)))
else ifeq ($(DOCKER_ARGS),image-pull)
	@more docker-compose.yml | grep image: | sed -e "s/^.*image:[[:space:]]//" | while read i; do docker pull $$i -q; done
else ifeq ($(DOCKER_ARGS),deploy)
	@docker stack deploy -c docker-compose.yml $(STACK)
else ifeq ($(DOCKER_ARGS),ls)
	@docker stack services $(STACK)
else ifeq ($(DOCKER_ARGS),stop)
	@docker stack rm $(STACK)
else
	@printf "${MISSING_ARGUMENTS}" docker
	$(call array_arguments, \
		["images"]="images" \
		["swarm-init"]="swarm init" \
		["login"]="login" \
		["create-network"]="create network" \
		["image-pull"]="Get docker image" \
		["deploy"]="deploy" \
		["ls"]="docker service" \
		["stop"]="docker stop" \
	)
endif

.PHONY: logs
logs: isdocker ### Scripts logs
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" logs
	$(call Docker_stack_container)
else
	@docker service logs -f --tail 100 --raw $(STACK)_$(DOCKER_ARGS).1.$$(docker service ps -f 'name=$(STACK)_$(DOCKER_ARGS)' $(STACK)_$(DOCKER_ARGS) -q --no-trunc | head -n1)
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
	@docker service inspect $(STACK)_$(DOCKER_ARGS)
endif

.PHONY: update
update: isdocker ### docker service update
ifeq ($(DOCKER_ARGS),)
	@printf "${MISSING_ARGUMENTS}" update
	$(call Docker_stack_container)
else
	@docker service update $(STACK)_$(DOCKER_ARGS)
endif