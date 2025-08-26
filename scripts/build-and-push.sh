#!/bin/bash

# Script de build et push Docker
# Usage: ./scripts/build-and-push.sh [tag]

set -e

TAG=${1:-latest}
DOCKER_USERNAME=${DOCKER_USERNAME:-"your-dockerhub-username"}
IMAGE_NAME="$DOCKER_USERNAME/gestion-even-stat"

echo "🔨 Construction et publication de l'image Docker"
echo "📦 Image: $IMAGE_NAME:$TAG"

# Vérifier que Docker est en cours d'exécution
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker n'est pas en cours d'exécution"
    exit 1
fi

# Construire l'image
echo "🔨 Construction de l'image..."
docker build -t "$IMAGE_NAME:$TAG" .

# Tagger comme latest si c'est la version principale
if [ "$TAG" != "latest" ]; then
    docker tag "$IMAGE_NAME:$TAG" "$IMAGE_NAME:latest"
fi

# Se connecter à Docker Hub (si pas déjà connecté)
if [ -n "$DOCKER_PASSWORD" ]; then
    echo "🔐 Connexion à Docker Hub..."
    echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
fi

# Pousser l'image
echo "⬆️ Publication de l'image..."
docker push "$IMAGE_NAME:$TAG"

if [ "$TAG" != "latest" ]; then
    docker push "$IMAGE_NAME:latest"
fi

# Afficher les informations de l'image
echo "📋 Informations de l'image:"
docker images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

echo "✅ Image publiée avec succès!"
echo "🐳 Pour l'utiliser: docker pull $IMAGE_NAME:$TAG"
