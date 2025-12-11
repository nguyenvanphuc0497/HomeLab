COMPOSE ?= docker compose
STACK ?= docker-compose.yml

.PHONY: deploy up down pull logs ps restart check

deploy: pull up

up:
	$(COMPOSE) -f $(STACK) up -d

down:
	$(COMPOSE) -f $(STACK) down

pull:
	$(COMPOSE) -f $(STACK) pull

logs:
	$(COMPOSE) -f $(STACK) logs -f --tail=100

ps:
	$(COMPOSE) -f $(STACK) ps

restart:
	$(COMPOSE) -f $(STACK) restart

check:
	$(COMPOSE) -f $(STACK) config

