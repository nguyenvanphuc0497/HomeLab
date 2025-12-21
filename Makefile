# Root Makefile for HomeLab project
# Provides convenient commands for development and validation

.PHONY: help validate validate-compose lint lint-markdown lint-yaml test clean test-all

help:
	@echo "HomeLab - Infrastructure as Code"
	@echo ""
	@echo "Available commands:"
	@echo "  make validate          - Validate all compose files and configs"
	@echo "  make validate-compose  - Validate Docker Compose files only"
	@echo "  make lint              - Run all linters (markdown, yaml)"
	@echo "  make lint-markdown     - Lint markdown files"
	@echo "  make lint-yaml         - Lint YAML files"
	@echo "  make test              - Run validation and linting"
	@echo "  make clean             - Clean temporary files"
	@echo ""
	@echo "Server-specific commands (cd servers/<server> first):"
	@echo "  make check             - Validate compose syntax"
	@echo "  make dry-run           - Show what would be deployed (no actual deploy)"
	@echo "  make test-deploy       - Test deploy with platform emulation (MacBook)"
	@echo "  make test-down         - Stop test containers"
	@echo "  make deploy            - Deploy to actual server"
	@echo ""
	@echo "Example workflow on MacBook:"
	@echo "  cd servers/raspi5"
	@echo "  make dry-run           # Preview deployment"
	@echo "  make test-deploy       # Test deploy (with ARM64 emulation)"
	@echo "  make logs              # Check logs"
	@echo "  make test-down         # Clean up"
	@echo ""
	@echo "See servers/README.md for details"

validate-compose:
	@echo "🔍 Validating Docker Compose files..."
	@bash scripts/validate-compose.sh

validate: validate-compose
	@echo "✅ All validations passed"

lint-markdown:
	@echo "📝 Linting Markdown files..."
	@if command -v markdownlint > /dev/null; then \
		markdownlint "**/*.md" --disable MD013 MD033; \
	else \
		echo "⚠️  markdownlint not installed. Install with: npm install -g markdownlint-cli"; \
	fi

lint-yaml:
	@echo "📋 Linting YAML files..."
	@if command -v yamllint > /dev/null; then \
		yamllint -d "{extends: relaxed, rules: {line-length: disable}}" .; \
	else \
		echo "⚠️  yamllint not installed. Install with: pip install yamllint"; \
	fi

lint: lint-markdown lint-yaml

test: validate lint
	@echo "✅ All tests passed"

deploy:
	@bash scripts/manage.sh deploy

down:
	@bash scripts/manage.sh down

config:
	@bash scripts/manage.sh config

prune:
	@bash scripts/manage.sh prune

clean-images:
	@bash scripts/manage.sh clean

clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -type f -name "*.swp" -delete
	@find . -type f -name "*.swo" -delete
	@find . -type f -name "*~" -delete
	@find . -type d -name ".DS_Store" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleanup complete"

