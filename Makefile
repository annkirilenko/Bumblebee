include .env

install: docker-build up post-install
up: docker-up
down: docker-down
restart: docker-down docker-up
clear: docker-down-clear

COMPOSE=docker compose -f docker-compose.yml -f docker-compose.local.yml

docker-build:
	@echo "build images"
	@docker build -t ${DOCKER_IMAGE_API} -f ./API/Dockerfile .
	@docker build -t ${DOCKER_IMAGE_WEB} -f ./Web/Dockerfile .
	@docker build --target builder -t ${DOCKER_IMAGE_WEB}-dev -f ./Web/Dockerfile .
	
docker-up:
	@echo "docker up"
	$(COMPOSE) up -d
	
docker-down:
	@echo "docker down"
	$(COMPOSE) down --remove-orphans

docker-down-clear:
	@echo "docker clear"
	$(COMPOSE) down -v --remove-orphans
	
post-install: 
	@echo "post install"
	
web-shell:
	$(COMPOSE) run --rm web /bin/sh