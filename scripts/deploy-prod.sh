#!/bin/bash

# Script de déploiement en production
# Usage: ./scripts/deploy-prod.sh [version]

set -e

VERSION=${1:-latest}
IMAGE_NAME="your-dockerhub-username/gestion-even-stat:$VERSION"

echo "🚀 Déploiement en production - Version: $VERSION"

# Vérifier les prérequis
if [ -z "$DOCKER_USERNAME" ] || [ -z "$DOCKER_PASSWORD" ]; then
    echo "❌ Variables d'environnement DOCKER_USERNAME et DOCKER_PASSWORD requises"
    exit 1
fi

# Se connecter à Docker Hub
echo "🔐 Connexion à Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

# Arrêter les conteneurs existants
echo "⏸️ Arrêt des conteneurs existants..."
docker-compose -f docker-compose.prod.yml down

# Sauvegarder l'image actuelle
echo "💾 Sauvegarde de l'image actuelle..."
docker tag "$IMAGE_NAME" "${IMAGE_NAME%:*}:previous" || true

# Télécharger la nouvelle image
echo "⬇️ Téléchargement de la nouvelle image..."
docker pull "$IMAGE_NAME"

# Démarrer avec la nouvelle image
echo "🚀 Démarrage avec la nouvelle image..."
export IMAGE_TAG="$VERSION"
docker-compose -f docker-compose.prod.yml up -d

# Attendre le démarrage
echo "⏳ Attente du démarrage..."
sleep 30

# Vérifier la santé de l'application
echo "🔍 Vérification de l'état de l'application..."
if curl -f http://localhost:80/health || curl -f http://localhost:80/ >/dev/null 2>&1; then
    echo "✅ Déploiement réussi!"
    
    # Nettoyer les anciennes images
    echo "🧹 Nettoyage des anciennes images..."
    docker image prune -f
    
    # Afficher les statistiques
    docker-compose -f docker-compose.prod.yml ps
    docker-compose -f docker-compose.prod.yml logs --tail=10
else
    echo "❌ Échec du déploiement - Rollback..."
    
    # Rollback
    docker-compose -f docker-compose.prod.yml down
    export IMAGE_TAG="previous"
    docker-compose -f docker-compose.prod.yml up -d
    
    echo "🔄 Rollback effectué"
    exit 1
fi

echo "🎉 Déploiement terminé avec succès!"
