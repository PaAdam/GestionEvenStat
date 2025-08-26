#!/bin/bash

# Script de déploiement local
# Usage: ./scripts/deploy-local.sh

set -e

echo "🚀 Déploiement local de Gestion Even Stat"

# Vérifier que Docker est en cours d'exécution
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker n'est pas en cours d'exécution"
    exit 1
fi

# Nettoyer les conteneurs existants
echo "🧹 Nettoyage des conteneurs existants..."
docker-compose down --remove-orphans

# Construire l'image
echo "🔨 Construction de l'image Docker..."
docker-compose build --no-cache

# Lancer l'application
echo "🚀 Lancement de l'application..."
docker-compose up -d

# Attendre que l'application soit prête
echo "⏳ Attente du démarrage de l'application..."
sleep 10

# Vérifier que l'application répond
if curl -f http://localhost:8080 >/dev/null 2>&1; then
    echo "✅ Application démarrée avec succès!"
    echo "🌐 Accessible sur: http://localhost:8080"
else
    echo "❌ L'application ne répond pas"
    docker-compose logs
    exit 1
fi

# Afficher les logs
echo "📋 Logs de l'application:"
docker-compose logs --tail=20
