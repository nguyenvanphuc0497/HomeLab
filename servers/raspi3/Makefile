COMPOSE ?= docker compose
STACK ?= docker-compose.yml
PLATFORM ?= linux/arm/v7

.PHONY: deploy up down pull logs ps restart check test-deploy dry-run pull-test test-down

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
	@echo "🔍 Validating $(STACK)..."
	@if [ -f .env ]; then \
		$(COMPOSE) -f $(STACK) config > /dev/null 2>&1 && echo "✅ Valid" || \
			($(COMPOSE) -f $(STACK) config 2>&1 | head -20 && exit 1); \
	else \
		echo "⚠️  No .env file found, validating syntax only..."; \
		$(COMPOSE) -f $(STACK) config 2>&1 | grep -v "\.env" | grep -v "variable" > /dev/null && echo "✅ Syntax valid (missing .env)" || \
			($(COMPOSE) -f $(STACK) config 2>&1 | grep -v "\.env" | head -20 || echo "⚠️  Some variables may be undefined (expected without .env)"); \
	fi

test-deploy: check pull-test
	@echo "🧪 Testing deploy (platform: $(PLATFORM))..."
	@echo "⚠️  This will start containers - use 'make test-down' to stop"
	@DOCKER_DEFAULT_PLATFORM=$(PLATFORM) $(COMPOSE) -f $(STACK) up -d

test-down:
	@echo "🛑 Stopping test containers..."
	@$(COMPOSE) -f $(STACK) down

pull-test:
	@echo "📥 Pulling images for platform $(PLATFORM)..."
	@DOCKER_DEFAULT_PLATFORM=$(PLATFORM) $(COMPOSE) -f $(STACK) pull

dry-run: check
	@echo "🔍 Dry run - showing what would be deployed:"
	@echo ""
	@echo "📋 Services:"
	@$(COMPOSE) -f $(STACK) config --services
	@echo ""
	@echo "📦 Images to pull:"
	@$(COMPOSE) -f $(STACK) config | grep -E "^\s+image:" | sed 's/.*image: //' | sort -u
	@echo ""
	@echo "✅ Configuration valid - ready to deploy"

