# Makefile pour Gestion Even Stat
.PHONY: help install build test docker-build docker-run docker-push deploy-local deploy-prod clean

# Variables
DOCKER_USERNAME ?= your-dockerhub-username
IMAGE_NAME = $(DOCKER_USERNAME)/gestion-even-stat
VERSION ?= latest

help: ## Afficher l'aide
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installer les dépendances
	npm install

build: ## Construire l'application Angular
	npm run build --prod

test: ## Exécuter les tests
	npm run test -- --watch=false --browsers=ChromeHeadless

lint: ## Vérifier le code
	npm run lint

dev: ## Lancer en mode développement
	npm start

docker-build: ## Construire l'image Docker
	docker build -t $(IMAGE_NAME):$(VERSION) .
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

docker-run: ## Lancer l'application avec Docker
	docker run -d -p 8080:80 --name gestion-even-stat $(IMAGE_NAME):latest

docker-push: docker-build ## Pousser l'image vers Docker Hub
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

docker-clean: ## Nettoyer les images Docker
	docker system prune -f
	docker image prune -f

compose-dev: ## Lancer avec Docker Compose (dev)
	docker-compose up -d

compose-prod: ## Lancer avec Docker Compose (prod)
	docker-compose -f docker-compose.prod.yml up -d

compose-down: ## Arrêter Docker Compose
	docker-compose down
	docker-compose -f docker-compose.prod.yml down

deploy-local: ## Déployer en local
	chmod +x scripts/deploy-local.sh
	./scripts/deploy-local.sh

deploy-prod: ## Déployer en production
	chmod +x scripts/deploy-prod.sh
	./scripts/deploy-prod.sh $(VERSION)

build-push: ## Construire et pousser l'image
	chmod +x scripts/build-and-push.sh
	./scripts/build-and-push.sh $(VERSION)

logs: ## Afficher les logs
	docker-compose logs -f

logs-prod: ## Afficher les logs de production
	docker-compose -f docker-compose.prod.yml logs -f

health: ## Vérifier l'état de l'application
	curl -f http://localhost:8080/ && echo "✅ Application OK" || echo "❌ Application KO"

clean: ## Nettoyer le projet
	npm run clean || true
	docker-compose down --remove-orphans || true
	docker-compose -f docker-compose.prod.yml down --remove-orphans || true
	docker container prune -f
	docker image prune -f
	rm -rf node_modules dist

setup: install build docker-build ## Configuration complète du projet

ci: install lint test build docker-build ## Pipeline CI complet

# Commandes de monitoring
stats: ## Afficher les statistiques Docker
	docker stats $(shell docker ps --format "{{.Names}}" | grep gestion-even-stat)

ps: ## Afficher les conteneurs en cours
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep gestion-even-stat || echo "Aucun conteneur en cours"
