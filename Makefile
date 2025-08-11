# DevOps Portfolio Makefile
# Author: Hubert Zych

.PHONY: help build run stop clean test deploy logs status

# Default target
.DEFAULT_GOAL := help

# Variables
DOCKER_IMAGE = portfolio
DOCKER_TAG = latest
CONTAINER_NAME = portfolio-app
PORT = 8080

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Show this help message
	@echo "DevOps Portfolio - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make build    # Build Docker image"
	@echo "  make run      # Run the application"
	@echo "  make test     # Run tests"
	@echo "  make deploy   # Full deployment"

build: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	sudo docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "$(GREEN)✅ Docker image built successfully$(NC)"

run: stop build ## Build and run the application
	@echo "$(YELLOW)Starting container...$(NC)"
	sudo docker run -d --name $(CONTAINER_NAME) -p $(PORT):80 --restart unless-stopped $(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "$(GREEN)✅ Application running at http://localhost:$(PORT)$(NC)"

stop: ## Stop and remove the container
	@echo "$(YELLOW)Stopping container...$(NC)"
	-sudo docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-sudo docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "$(GREEN)✅ Container stopped$(NC)"

clean: stop ## Clean up containers and images
	@echo "$(YELLOW)Cleaning up...$(NC)"
	-sudo docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG) 2>/dev/null || true
	-sudo docker system prune -f
	@echo "$(GREEN)✅ Cleanup completed$(NC)"

test: ## Run application tests
	@echo "$(YELLOW)Running tests...$(NC)"
	sudo docker build -t $(DOCKER_IMAGE):test .
	sudo docker run -d --name $(CONTAINER_NAME)-test -p 9999:80 $(DOCKER_IMAGE):test
	@sleep 5
	@if curl -f http://localhost:9999/health > /dev/null 2>&1; then \
		echo "$(GREEN)✅ Health check passed$(NC)"; \
	else \
		echo "$(RED)❌ Health check failed$(NC)"; \
		sudo docker stop $(CONTAINER_NAME)-test; \
		sudo docker rm $(CONTAINER_NAME)-test; \
		exit 1; \
	fi
	@if curl -f http://localhost:9999/ > /dev/null 2>&1; then \
		echo "$(GREEN)✅ Main page test passed$(NC)"; \
	else \
		echo "$(RED)❌ Main page test failed$(NC)"; \
		sudo docker stop $(CONTAINER_NAME)-test; \
		sudo docker rm $(CONTAINER_NAME)-test; \
		exit 1; \
	fi
	sudo docker stop $(CONTAINER_NAME)-test
	sudo docker rm $(CONTAINER_NAME)-test
	sudo docker rmi $(DOCKER_IMAGE):test
	@echo "$(GREEN)✅ All tests passed$(NC)"

deploy: test run ## Run tests and deploy the application
	@echo "$(GREEN)🚀 Deployment completed successfully!$(NC)"
	@echo "$(YELLOW)📱 Access your portfolio at: http://localhost:$(PORT)$(NC)"

logs: ## Show container logs
	@echo "$(YELLOW)Container logs:$(NC)"
	sudo docker logs $(CONTAINER_NAME) --tail 50 -f

status: ## Show container status
	@echo "$(YELLOW)Container status:$(NC)"
	sudo docker ps -f name=$(CONTAINER_NAME)
	@echo ""
	@echo "$(YELLOW)System resources:$(NC)"
	sudo docker stats $(CONTAINER_NAME) --no-stream

dev: ## Start development mode with Docker Compose
	@echo "$(YELLOW)Starting development environment...$(NC)"
	sudo docker-compose up -d
	@echo "$(GREEN)✅ Development environment ready$(NC)"

prod: ## Start production mode with Docker Compose
	@echo "$(YELLOW)Starting production environment...$(NC)"
	sudo docker-compose --profile production up -d
	@echo "$(GREEN)✅ Production environment ready$(NC)"

down: ## Stop Docker Compose services
	@echo "$(YELLOW)Stopping Docker Compose services...$(NC)"
	sudo docker-compose down
	@echo "$(GREEN)✅ Services stopped$(NC)"

lint: ## Run code quality checks
	@echo "$(YELLOW)Running code quality checks...$(NC)"
	@if command -v htmlhint > /dev/null; then \
		htmlhint index.html; \
	else \
		echo "$(YELLOW)⚠️  HTMLHint not installed$(NC)"; \
	fi
	@echo "$(GREEN)✅ Code quality checks completed$(NC)"

security: ## Run security scans
	@echo "$(YELLOW)Running security scans...$(NC)"
	sudo docker run --rm -v $(PWD):/app -w /app aquasec/trivy fs .
	@echo "$(GREEN)✅ Security scan completed$(NC)"

backup: ## Create backup of the application
	@echo "$(YELLOW)Creating backup...$(NC)"
	sudo docker save $(DOCKER_IMAGE):$(DOCKER_TAG) > portfolio-backup-$(shell date +%Y%m%d_%H%M%S).tar
	@echo "$(GREEN)✅ Backup created$(NC)"

restore: ## Restore from backup (requires BACKUP_FILE variable)
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "$(RED)❌ Please specify BACKUP_FILE variable$(NC)"; \
		echo "Example: make restore BACKUP_FILE=portfolio-backup-20250101_120000.tar"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring from $(BACKUP_FILE)...$(NC)"
	sudo docker load < $(BACKUP_FILE)
	@echo "$(GREEN)✅ Backup restored$(NC)"

health: ## Check application health
	@echo "$(YELLOW)Checking application health...$(NC)"
	@if curl -f http://localhost:$(PORT)/health > /dev/null 2>&1; then \
		echo "$(GREEN)✅ Application is healthy$(NC)"; \
	else \
		echo "$(RED)❌ Application health check failed$(NC)"; \
		exit 1; \
	fi

benchmark: ## Run performance benchmark
	@echo "$(YELLOW)Running performance benchmark...$(NC)"
	@if command -v ab > /dev/null; then \
		ab -n 1000 -c 10 http://localhost:$(PORT)/; \
	else \
		echo "$(YELLOW)⚠️  Apache Bench (ab) not installed$(NC)"; \
		echo "Install with: sudo apt-get install apache2-utils"; \
	fi

monitor: ## Monitor container resources
	@echo "$(YELLOW)Monitoring container resources (Press Ctrl+C to stop)...$(NC)"
	sudo docker stats $(CONTAINER_NAME)

shell: ## Access container shell
	@echo "$(YELLOW)Accessing container shell...$(NC)"
	sudo docker exec -it $(CONTAINER_NAME) /bin/sh
